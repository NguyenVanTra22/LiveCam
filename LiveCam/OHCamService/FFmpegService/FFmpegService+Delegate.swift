//
//  FFmpegService+Delegate.swift
//  OneHome
//
//  Created by ThiemJason on 8/19/22.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

import Foundation
import mobileffmpeg
import UIKit

// MARK: - FFmpegManager Delegate
protocol FFmpegServiceDelegate : NSObject {
    func onFFmpegSessionExecutedSuccess(_ session: FFmpegSession?)
    func onFFmpegSessionExecutedFailed(_ session: FFmpegSession?)
    func onFFmpegSessionExecutedCancel(_ session: FFmpegSession?)
}

extension FFmpegServiceDelegate {
    func onFFmpegSessionExecutedSuccess(_ session: FFmpegSession?) {}
    func onFFmpegSessionExecutedFailed(_ session: FFmpegSession?) {}
    func onFFmpegSessionExecutedCancel(_ session: FFmpegSession?) {}
}

// MARK: - Handle all delegate
extension FFmpegService {
    /// Lắng nghe thay đổi của `App life cycle`
    public func registerAppLifeCycle() {
        /// `Foreground`
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDeviceMoveToForeground),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        /// `Background`
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDeviceMoveToBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        /// `Terminated`
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDeviceTerminated),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }
    
    /// `Foreground`
    @objc func onDeviceMoveToForeground() {
        print("🚀FFMpeg-Manager🚀       | onDeviceMoveToForeground ")
        if self.sessionQueue.isEmpty == false {
            self.sessionQueue.forEach { session in
                if (session.state.value ?? .Cancel) == .Cancel {
                    DispatchQueue.main.async {
//                        AppMessagesManager.shared.showMessage(messageType: .error, message: dLocalized("KEY_ERROR_PLAYBACK_DOWNLOAD_CLOUD_FAILURE"))
                    }
                }
            }
            self.sessionQueue.removeAll()
        }
    }
    
    /// `Background`
    @objc func onDeviceMoveToBackground() {
        print("🚀FFMpeg-Manager🚀       | onDeviceMoveToBackground ")
        /// Khi ứng dụng xuống `Background`, cần `DỪNG` toàn bộ các trình `FFmpeg`
        if self.sessionQueue.isEmpty == false {
            MobileFFmpeg.cancel()
            self.sessionQueue.removeAll()
        }
    }
    
    /// `Terminated`
    @objc func onDeviceTerminated() {
        print("🚀FFMpeg-Manager🚀       | onDeviceTerminated ")
    }
}

// MARK: - FFmpeg Execute Delegate
extension FFmpegService : ExecuteDelegate {
    
    /// `FFmpeg execute Callback`
    func executeCallback(_ executionId: Int, _ returnCode: Int32) {
        
        /// Lấy ra `session` tương ứng với `executionId`
        guard let executedSession = self.sessionQueue.filter({ Int($0.executionId.value ?? 0) == executionId }).first else { return }
        
        /// Xử lỹ mã trả về
        switch returnCode {
        case RETURN_CODE_SUCCESS:
            self.onFFmpegSessionExecutedSuccess(executedSession)
        case RETURN_CODE_CANCEL:
            self.onFFmpegSessionExecutedCancel(executedSession)
        default:
            print("--- \(MobileFFmpegConfig.getLastCommandOutput() ?? "")");
            self.onFFmpegSessionExecutedFailed(executedSession)
        }
        self.handlerSessionAction(executedSession)
    }
    
    /// `Thành công`
    public func onFFmpegSessionExecutedSuccess(_ session: FFmpegSession?) {
        guard let session = session else { return }
        /// `QUAN TRỌNG` ==> `Cập nhật trạng thái của Session`
        session.state.accept(.Successfully)
        self.delegate?.onFFmpegSessionExecutedSuccess(session)
    }
    
    /// `Bị buộc dừng`
    public func onFFmpegSessionExecutedCancel(_ session: FFmpegSession?) {
        guard let session = session else { return }
        /// `QUAN TRỌNG` ==> `Cập nhật trạng thái của Session`
        session.state.accept(.Cancel)
        self.delegate?.onFFmpegSessionExecutedCancel(session)
    }
    
    /// `Bị failed (ví dụ lệnh gọi bị sai do dữ liệu đầu vào sai )`
    public func onFFmpegSessionExecutedFailed(_ session: FFmpegSession?) {
        guard let session = session else { return }
        /// `QUAN TRỌNG` ==> `Cập nhật trạng thái của Session`
        session.state.accept(.Failed)
        self.delegate?.onFFmpegSessionExecutedFailed(session)
    }
    
    /// Xử lý các `Option`
    public func handlerSessionAction(_ ffmpegSession: FFmpegSession?) {
        guard let ffmpegSession = ffmpegSession else { return }
        
        /// `Delete` ==> `BaseFile`
        if ffmpegSession.option.value.contains(.deleteBaseFile) {
            self.deleteFileWithPath(path: ffmpegSession.basePath.value) { isSuccess in
                print("🚀FFMpeg-Manager🚀       | deleteFileWithPath  basePath \(isSuccess)")
            }
        }
        
        /// `Delete` ==> `Destination file`
        if ffmpegSession.option.value.contains(.deleteDestinationFile) {
            self.deleteFileWithPath(path: ffmpegSession.destinationPath.value) { isSuccess in
                print("🚀FFMpeg-Manager🚀       | deleteFileWithPath  deleteDestinationFile \(isSuccess)")
            }
        }
        
        /// `Không xử lý được ở đây vì cần ảnh snapshot`
        if ffmpegSession.option.value.contains(.saveToAppVideo) {}
    }
}

// MARK: - Statistic
extension FFmpegService : StatisticsDelegate {
    
    /// Hàm delegate `StatisticsDelegate`
    /// - Parameter statistics
    func statisticsCallback(_ statistics: Statistics!) {
        guard let _statistics   = statistics else { return }
        guard let session           = self.sessionQueue.filter({ Int($0.executionId.value ?? 0) == _statistics.getExecutionId() }).first else { return }
        
        /// `FFMpegConfig` caching lại command cuối cùng nên bị hiển thị sai `ProgressTime`
        if let lastFileTime = session.lastFileTime.value {
            if _statistics.getTime() == lastFileTime && (lastFileTime > 0) {
                return
            }
        }
        
        guard let progressPercent   = self.getProgressPercent(session.mediaDuration.value, _statistics) else { return  }
        
        /// Update `Session`
        session.progresValue.accept(progressPercent)
        session.statistic.accept(_statistics)
        
        /// `Update` trở lại `Queue`
        print("🚀FFMpeg-Manager🚀  id: \(session.executionId.value) || progress: \(progressPercent) || duration: \(session.mediaDuration.value) ")
    }
    
    
    /// Lấy ra `Progress percent`
    /// - Parameters:
    ///   - session: `FFmpegSession`
    ///   - mediaInfo: `MediaInfomation`
    /// - Returns: `Double?`
    func getProgressPercent( _ duration: Double?, _ statistic: Statistics? ) -> Double? {
        guard let fileDuration  = duration,
              let statistic     = statistic else { return nil }
        
        /// Lấy `time`
        let timeConverted       = Double(statistic.getTime())
        
        /// Tính `progress percent`
        return  min(100, (timeConverted / (fileDuration * 1000.0)) * 100)
    }
}

// MARK: - Log delegate
extension FFmpegService : LogDelegate {
    func logCallback(_ executionId: Int, _ level: Int32, _ message: String!) {}
}

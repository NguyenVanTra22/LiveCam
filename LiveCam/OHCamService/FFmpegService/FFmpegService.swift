//
//  FFmpegService.swift
//  OneHome
//
//  Created by ThiemJason on 8/19/22.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

import Foundation
import mobileffmpeg

// MARK: - Completion define
typealias FunctionCompletion = ((_ isSuccess : Bool) -> Void)

// MARK: Main class
class FFmpegService : NSObject {
    // MARK: - Property
    /// `Singleton`
    static let shared                       = FFmpegService()
    
    /// `Session list`
    var sessionQueue                        = Set<FFmpegSession>()
    
    // MARK: - Delegate
    weak var delegate                       : FFmpegServiceDelegate?
    
    // MARK: - Initialized
    public override init() {}
    /** IMPORTANT: Need to init when application started */
    public func initializedFFmpegManager() {
        self.registerAppLifeCycle()
        MobileFFmpegConfig.setStatisticsDelegate(self)
        MobileFFmpegConfig.setLogDelegate(self)
    }
}

// MARK: - FFmpegManager control
extension FFmpegService {
    
    /// Hàm đẩy `session` vào `Queue` và thực hiện `Excute`
    public func scheduleSession(session: FFmpegSession?,
                                _ completion: @escaping FunctionCompletion = { _ in } ) {
        guard let session = session else {
            completion(false)
            return
        }
        
        /// Insert vào `Queue`
        self.sessionQueue.insert(session)
        
        // MARK: Dùng tạm
        self.executeSession(session) {(isSuccess) in
            completion(isSuccess)
        }
    }
    
    /// `Execute session`
    public func executeSession(_ session: FFmpegSession?,
                               _ completion: @escaping FunctionCompletion = { _ in } ) {
        guard let session = session,
              let command = session.executionCommand.value else {
            completion(false)
            return;
        }
        
        /// Kiểm tra `Session` phải ở trạng thái `Pending`
        if session.state.value != .Pending {
            completion(false)
            return;
        }
        
        /// Cần giữ lại `ID của lệnh`
        let executionId = MobileFFmpeg.executeAsync(command, withCallback: self)
        
        /// Cập nhật lại `State` + `executionId`  của `session` đó
        session.state.accept(.Inprogress)
        session.executionId.accept(executionId)
        completion(true)
        print("🚀FFMpeg-Manager🚀 executeSession id: \(executionId) || basePath: \(session.basePath.value)")
    }
    
    /// `Execute` nhiều `session` cùng lúc
    public func executeMultiSession(_ sessions: [FFmpegSession],
                                    _ completion: @escaping FunctionCompletion = { _ in } ) {
        /// Empty
        if sessions.isEmpty {
            completion(false)
            return;
        }
        
        /// Thực hiện lệnh cho toàn bộ `Session` đã chon
        var executedSession     = [FFmpegSession]()
        sessions.forEach { (session) in
            if let command = session.executionCommand.value, session.state.value != .Pending {
                /// Cần giữ lại `ID của lệnh`
                let executionId = MobileFFmpeg.executeAsync(command, withCallback: self)
                
                let updatedSession              = session
                /// Cập nhật lại `State` + `executionId`  của `session` đó
                updatedSession.state.accept(.Inprogress)
                updatedSession.executionId.accept(executionId)
                executedSession.append(updatedSession)
            } else {
                executedSession.append(session)
            }
        }
        completion(true)
    }
    
    /// `Clear all current session`
    public func clearAllSession() {
        if self.sessionQueue.isEmpty == false {
            MobileFFmpeg.cancel()
            self.sessionQueue.removeAll()
        }
    }
    
    /// `Cancel` toàn bộ các session hiện tại
    public func clearSession(_ session: FFmpegSession?,
                             _ completion: @escaping FunctionCompletion = { _ in } ) {
        guard let session = session,
              let executionID = session.executionId.value,
              session.state.value == .Inprogress else {
            completion(false)
            return
        }
        MobileFFmpeg.cancel(Int(executionID))
        completion(true)
    }
    
    /// Xóa một file nào đó
    public func deleteFileWithPath(path: String?, completion: @escaping ((Bool) -> Void)) {
        guard let path = path,
              let pathUrl = URL(string: path) else {
            completion(false)
            return
        }
        do {
            try FileManager.default.removeItem(at: pathUrl)
            completion(true)
        } catch  {
            print(error.localizedDescription)
            completion(false)
        }
    }
}

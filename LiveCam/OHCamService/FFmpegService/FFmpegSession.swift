//
//  FFmpegSession.swift
//  OneHome
//
//  Created by ThiemJason on 8/19/22.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

import Foundation
import mobileffmpeg
import RxSwift
import RxCocoa

// MARK: - State
enum FFmpegSessionState {
    case Pending
    case Inprogress
    case Successfully
    case Failed
    case Cancel
}

// MARK: - Action
enum FFmpegSessionAction {
    case convertH265withAACtoMP4
    case convertH265toMp4
    case convertM3u8toMP4
    case convertH265toMov
}

// MARK: - Option
enum FFmpegSessionOption {
    case saveToAlbum
    case saveToAppVideo
    case noneSave
    case deleteBaseFile
    case deleteDestinationFile
}

struct FFmpegSession {
    /// `Identifier`
    var uuid                = BehaviorRelay<String?>(value: nil)
    var executionId         = BehaviorRelay<Int32?>(value: nil)
//    var device              = BehaviorRelay<Device?>(value: nil)
    
    /// `Execution time`
    var timestamp           = BehaviorRelay<Date?>(value: nil)
    
    var mediaDuration       = BehaviorRelay<Double?>(value: nil)
    var statistic           = BehaviorRelay<Statistics?>(value: nil)
    var lastFileTime        = BehaviorRelay<Int32?>(value: nil)
    var progresValue        = BehaviorRelay<Double?>(value: nil)
    
    /// `Command`
    var executionCommand    = BehaviorRelay<String?>(value: nil)
    
    /// `File path`
    var destinationPath     = BehaviorRelay<String?>(value: nil)
    
    /// `File gốc nằm trên Thiết bị`
    var basePath            = BehaviorRelay<String?>(value: nil)
    
    /// `File audio nằm trên Thiết bị`
    var audioPath           = BehaviorRelay<String?>(value: nil)
    
    /// `File nằm trên BackEnd`
    var remoteFilePath      = BehaviorRelay<String?>(value: nil)
    
    /// `Action - State - Option`
    var state               = BehaviorRelay<FFmpegSessionState?>(value: nil)
    var action              = BehaviorRelay<FFmpegSessionAction?>(value: nil)
    var option              = BehaviorRelay<[FFmpegSessionOption]>(value: [])
    
    /// `Init function`
//    public static func createSession( device: Device?,
//                                      destinationPath: String?,
//                                      basePath: String?,
//                                      audioPath: String?,
//                                      remoteFilePath: String?,
//                                      state: FFmpegSessionState,
//                                      action: FFmpegSessionAction,
//                                      option: [FFmpegSessionOption]) -> FFmpegSession {
//        let session                 = FFmpegSession()
//        session.uuid.accept(UUID().uuidString)
//        session.device.accept(device)
//        session.timestamp.accept(Date())
//        session.destinationPath.accept(destinationPath)
//        session.basePath.accept(basePath)
//        session.audioPath.accept(audioPath)
//        session.remoteFilePath.accept(remoteFilePath)
//        session.state.accept(state)
//        session.action.accept(action)
//        session.option.accept(option)
//        session.mediaDuration.accept(Double(getMediaDuration(url: URL(string: remoteFilePath ?? ""))))
//        session.lastFileTime.accept(MobileFFmpegConfig.getLastReceivedStatistics().getTime())
//        session.executionCommand.accept(FFmpegSession.getCommandFromAction(basePath: basePath,
//                                                                           audioPath: audioPath,
//                                                                           destinationPath: destinationPath,
//                                                                           action: action))
//        return session
//    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid.value ?? UUID().uuidString)
    }
    
    /// Lấy `Command` từ `Path` + `Action`
    public static func getCommandFromAction(basePath: String?, audioPath: String? , destinationPath: String?, action: FFmpegSessionAction) -> String? {
        guard let basePath = basePath,
              let desPath = destinationPath else {
            return nil
        }
        
        switch action {
        case .convertH265toMov:
            return "-hwaccel videotoolbox -i \(basePath) -y -map 0 -c:v libx264 -crf 18 -c:a copy \(desPath)"
        case .convertH265toMp4:
            return "-hwaccel videotoolbox -i \(basePath) -y -map 0 -c:v libx264 -crf 18 -c:a copy \(desPath)"
        case .convertM3u8toMP4:
            return "-hwaccel videotoolbox -i \(basePath) -y -map 0 -c:v h264_videotoolbox -b:v 5M -q:v 100 -c:a copy \(desPath)"
            //return "-hwaccel videotoolbox -protocol_whitelist file,http,https,tcp,tls,crypto -i \(basePath) -y -max_muxing_queue_size 9999 -c:v copy -c:a aac -b:a 128k -tag:v hvc1 \(desPath)"
            //return "-hwaccel videotoolbox -protocol_whitelist file,http,https,tcp,tls,crypto -i \(basePath) -y -vcodec copy -tag:v hvc1 \(desPath)"
            //return "-i \(basePath) -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 \(desPath)"
            //return "-hwaccel videotoolbox -protocol_whitelist file,http,https,tcp,tls,crypto -i \(basePath) -y -map 0 -c:v libx264 -crf 18 -c:a copy \(desPath)"
        case .convertH265withAACtoMP4:
            guard let audioPath = audioPath else { return nil }
            return "-hwaccel videotoolbox -i \(basePath) -i \(audioPath) -y -map 0 -c:v libx264 -crf 18 -c:a copy \(desPath)"
        }
    }
}

extension FFmpegSession : Equatable, Hashable {
    static func == (lhs: FFmpegSession, rhs: FFmpegSession) -> Bool {
        return lhs.uuid.value == rhs.uuid.value
    }
}

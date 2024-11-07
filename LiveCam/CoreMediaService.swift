//
//  CoreMediaService.swift
//  OneHome
//
//  Created by ThiemJason on 09/02/2023.
//  Copyright © 2023 VNPT Technology. All rights reserved.
//

import Foundation
import AVFoundation
import KHJCameraLib
import OpenGLES
import Accelerate
import UIKit
import RxSwift
import RxCocoa

class CoreMediaService {
    /// `Singleton`
    fileprivate init() {
        // Đăng ký sự kiện AVAudioSessionRouteChangeNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioRouteChanged(_:)),
                                               name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    static let shared               = CoreMediaService()
    
    /// `Media Engine`
    fileprivate var audioEngine     = AVAudioEngine()
    fileprivate var TWAEngine       = AVAudioEngine()
    fileprivate var audioFormat     = AVAudioFormat()
    fileprivate var audioPlayerNode = AVAudioPlayerNode()
    fileprivate var isPlayingAudio  = false
    
    /// `Multithreading`
    public var threadAudioDecode            = DispatchQueue(label: "\(Constant.threadNamePrefix)CoreMediaService.audioDecode", attributes: .concurrent)
    public var threadCallApi                = DispatchQueue(label: "\(Constant.threadNamePrefix)CoreMediaService.callApi", attributes: .concurrent)
    public var threadAudioPlay              = DispatchQueue(label: "\(Constant.threadNamePrefix)CoreMediaService.audioPlay", attributes: .concurrent)
    public var threadTWADecode              = DispatchQueue(label: "\(Constant.threadNamePrefix)CoreMediaService", attributes: .concurrent)
    
    /// `ReactiveX`
    public let rxAudioMicroResponse         : PublishSubject<[UInt8]> = PublishSubject()
    
    /// `Haptics`
    static let hapticsIntensity             : Float = 0.5
    static let hapticsDuration              : Double = 0.3
    
    /// `Screen lock timer`
    internal var timerWakeUpScr             : Timer?
    static let timeoutWakeUpScr             = 0 // second. 0 tương ứng là không tắt màn hình
}

enum CameraState {
    case start
    case recording
    case paused
    case stopped
}

// MARK: Initialized TWA
extension CoreMediaService {
    /// `Kiểm tra audio`
    func isTWAStillRuning() -> Bool {
        return self.TWAEngine.isRunning
    }
    
    // MARK: Two way audio control
    func onCameraTWAControlbyState(_ state: CameraState, completion: @escaping ((_ isSuccess: Bool) -> Void) = { _ in }) {
        switch state {
        case .start:
            self.startSendAudio() { isSuccess in
                completion(isSuccess)
            }
        case .recording:
            self.resumeSendAudio { isSuccess in
                completion(isSuccess)
            }
        case .paused:
            self.pauseSendAudio { isSuccess in
                completion(isSuccess)
            }
        case .stopped:
            self.stopSendAudio { isSuccess in
                completion(isSuccess)
            }
        }
    }
    
    private func startSendAudio(completion: @escaping ((_ isSuccess: Bool) -> Void) = { _ in }) {
        do {
            _ = try self.TWAEngine.start()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    private func pauseSendAudio(completion: @escaping ((_ isSuccess: Bool) -> Void) = { _ in }) {
        self.TWAEngine.pause()
        completion(true)
    }
    
    private func resumeSendAudio(completion: @escaping ((_ isSuccess: Bool) -> Void) = { _ in }) {
        self.setupAudioSession()
        do {
            _ = try self.TWAEngine.start()
            completion(true)
        } catch {
            print("====> \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func stopSendAudio(completion: @escaping ((_ isSuccess: Bool) -> Void) = { _ in }) {
        self.TWAEngine.stop()
        completion(true)
    }
    
    func deInitialzedTWA() {
        self.TWAEngine.inputNode.removeTap(onBus: 0)
        self.TWAEngine.stop()
        print("===> 🎧🎧🎧 CoreMedia service deInitialzedTWA")
    }
    
    /// Trong trường hợp rất hi hữu bị crash ở đây
    /// Crash tại hàm `let inputFormat = inputNode.outputFormat(forBus: 0)` , `inputFormat` bị báo `null`.
    ///  Fatal Exception: com.apple.coreaudio.avfaudio
    /// required condition is false: IsFormatSampleRateAndChannelCountValid(format)
    func initialzedTWA() {
        var inputNode = self.TWAEngine.inputNode
        var inputFormat = inputNode.inputFormat(forBus: 0)
        
        if inputFormat.sampleRate <= 0 {
            self.TWAEngine.reset()
            inputNode   = self.TWAEngine.inputNode
            inputFormat = inputNode.inputFormat(forBus: 0)
        }
        
        let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: Constant.OHCamera.AudioFormat.audioRate, channels: AVAudioChannelCount(Constant.OHCamera.AudioFormat.audioChannel), interleaved: true)!
        
        guard let converter: AVAudioConverter = AVAudioConverter(from: inputFormat, to: outputFormat) else {
            print("Can't convert in to this format")
            return
        }
        
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) {[weak self] (buffer, time) in
            guard let `self` = self else { return }
            var newBufferAvailable = true
            
            let inputCallback: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                if newBufferAvailable {
                    outStatus.pointee = .haveData
                    newBufferAvailable = false
                    return buffer
                } else {
                    outStatus.pointee = .noDataNow
                    return nil
                }
            }
            
           self.threadTWADecode.async {
                let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate))!
                
                var error: NSError?
                    let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
                assert(status != .error)
                
                // duoc chua
                let data = self.copyAudioBufferBytes(convertedBuffer)
                self.rxAudioMicroResponse.onNext(data)
            }
        }
        self.TWAEngine.prepare()
        print("===> 🎧🎧🎧 CoreMedia service initialzedTWA")
    }
    
    private func copyAudioBufferBytes(_ audioBuffer: AVAudioPCMBuffer) -> [UInt8] {
        let srcLeft = audioBuffer.int16ChannelData![0]
        let bytesPerFrame = audioBuffer.format.streamDescription.pointee.mBytesPerFrame
        let numBytes = Int(bytesPerFrame * audioBuffer.frameLength)
        
        // initialize bytes to 0 (how to avoid?)
        var audioByteArray = [UInt8](repeating: 0, count: numBytes)
        
        // copy data from buffer
        srcLeft.withMemoryRebound(to: UInt8.self, capacity: numBytes) { srcByteData in
            audioByteArray.withUnsafeMutableBufferPointer {
                $0.baseAddress!.initialize(from: srcByteData, count: numBytes)
            }
        }
        
        return audioByteArray
    }
}

// MARK: Initialized Audio
extension CoreMediaService {

    /// `Kiểm tra audio`
    func isAudioStillRuning() -> Bool {
        return self.audioEngine.isRunning && self.audioPlayerNode.isPlaying
    }
    
    /// onCameraManagerReceiveAudioData
    /// Data input là kiểu Pcm16
    /// Cần chặt ra các khoảng 256 bytes để mang đi play ( bởi vì audio rate = 8000 )
    /// Convert sang AVAudioPCMBUffer để play
    /// - Parameters:
    ///   - buffer:          Audio datapayload
    ///   - length:          Audio payload length
    /// - Returns:              `Void`
    func onCameraManagerReceiveAudioData(_ buffer: UnsafeMutablePointer<Int8>, _ length: Int) {
        //print("len: \(length)   audEng: \(self.audioEngine.isRunning)   node: \(self.audioPlayerNode.isPlaying) isPlaying: \(self.isPlayingAudio)")
        if (self.audioEngine.isRunning && self.audioPlayerNode.isPlaying) == false { return }
        if self.isPlayingAudio == false { return }
        
        self.threadAudioDecode.async {
            if length == 0 { return }
            let data = Data(bytes: buffer, count: Int(length))
            let size = MemoryLayout<Int16>.stride
            let int16s = data.withUnsafeBytes { (bytes: UnsafePointer<Int16>) in
                Array(UnsafeBufferPointer(start: bytes, count: data.count / size))
            }
            
            let arrayChunks = int16s.chunked(into: Constant.OHCamera.AudioFormat.bufferSize)
            //print("==> Play audio: \(arrayChunks.count) vol: \(self.audioPlayerNode.volume)")
            self.threadAudioPlay.async {
                arrayChunks.forEach { audioData in
                    if audioData.isEmpty { return }
                    let pcmBuffer = self.getPcmFloat32Buffer(audioData)
                    self.playAudio(pcmBuffer)
                }
            }
        }
    }
    
    /// getPcmFloat32Buffer
    /// - Parameters:
    ///   - bytesInt16:          `[Int16]` Nhận input là [Int16] để converrt sang AVAudioPCMbuffer
    /// - Returns:              `Void`
    func getPcmFloat32Buffer(_ bytesInt16: [Int16]) -> AVAudioPCMBuffer {
        if let buffer = AVAudioPCMBuffer(pcmFormat: self.audioFormat, frameCapacity: UInt32(Constant.OHCamera.AudioFormat.bufferSize)) {
            
            let monoChannel = buffer.floatChannelData![0]
            var byteDataFloat32 = [Float32](repeating: 0.0, count: Constant.OHCamera.AudioFormat.bufferSize)
            
            // Int16 ranges from -32768 to 32767 -- we want to convert and scale these to Float values between -1.0 and 1.0
            var scale = Float(Int16.max) + 1.0
            vDSP_vflt16(bytesInt16, 1, &byteDataFloat32, 1, vDSP_Length(Constant.OHCamera.AudioFormat.bufferSize)) // Int16 to Float
            vDSP_vsdiv(byteDataFloat32, 1, &scale, &byteDataFloat32, 1, vDSP_Length(Constant.OHCamera.AudioFormat.bufferSize)) // divide by scale
            
            memcpy(monoChannel, byteDataFloat32, Constant.OHCamera.AudioFormat.bufferByteSize)
            buffer.frameLength = UInt32(Constant.OHCamera.AudioFormat.bufferSize)
            return buffer
        } else {
            return AVAudioPCMBuffer()
        }
    }
    
    /// playAudio
    ///  Hàm với input là AVFrame và play video trực tiếp trên OpenGLView là property của VNPTCamera Manager
    /// - Parameters:
    ///   - buffer:          Session để xử lý case multiple connection tới các camera khác nhau.
    /// - Returns:              `Void`
    func playAudio(_ buffer: AVAudioPCMBuffer?) {
        guard let pcmBuffer = buffer else { return }
        self.audioPlayerNode.scheduleBuffer(pcmBuffer, completionHandler: nil)
    }
    
    /// Hàm play audio
    /// - Hàm play audio engine
    /// - Parameters:
    ///   - isOn:               `True` Có nhận audio, `False`:  Không nhận audio:
    /// - Returns:              `Void`
    func isPlayAudio(_ isOn: Bool) {
        if !self.audioEngine.isRunning { return }
        self.isPlayingAudio         = isOn
        self.audioPlayerNode.volume = isOn ? 1.0 : 0.0
    }
    
    func initializedAudio() {
        /** Int audio format and audio engine */
        self.audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                         sampleRate: Constant.OHCamera.AudioFormat.audioRate,
                                         channels: AVAudioChannelCount(Constant.OHCamera.AudioFormat.audioChannel),
                                         interleaved: false)!
        
        self.audioEngine        = AVAudioEngine()
        self.audioPlayerNode    = AVAudioPlayerNode()
        
        let mainMixer = self.audioEngine.mainMixerNode
        self.audioEngine.reset()
        self.audioPlayerNode.reset()
        self.audioEngine.attach(self.audioPlayerNode)
        self.audioEngine.connect(self.audioPlayerNode, to: mainMixer, format: self.audioFormat)
        
        if !self.audioEngine.isRunning {
            self.audioEngine.prepare()
            do {
                try self.audioEngine.start()
                self.audioPlayerNode.play()
                print("===> 🎧🎧🎧 CoreMedia service initializedAudio")
            } catch {
                print(" 🚫🚫🚫🚫🚫🚫 ===> CoreMedia service \(error.localizedDescription)")
            }
        }
        
        self.audioPlayerNode.volume = 0.0
    }
    
    func deInitializedCameraAudio() {
        self.audioPlayerNode.stop()
        self.audioEngine.stop()
        print("===> 🎧🎧🎧 CoreMedia service deInitializedCameraAudio")
    }
    
    /** Setup audio session */
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        if session.category == .playAndRecord { return }
        print("===> 🎧🎧🎧 CoreMedia service setupAudioSession")
        
        do {
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowBluetooth, .allowAirPlay])
            //try? session.overrideOutputAudioPort(.speaker)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error setupAudioSession: \(error.localizedDescription)")
        }
    }
    
    // Hàm xử lý sự kiện thay đổi đường dẫn âm thanh
    @objc func audioRouteChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            if self.isPlayingAudio && (UIApplication.shared.applicationState != .background) {
                /** `Trong một vài trường hợp Background -> Foreground` `AVAudioEngine` bị stop dẫn tới k play được */
                /** Giải pháp gọi init lại audio */
                self.initializedAudio()
                self.audioPlayerNode.volume = 1.0
            }
            // UnComment nếu muốn debug
            //print("Change to device: \(AVAudioSession.sharedInstance().currentRoute.outputs)")
            //print("playerNodeRunnging: \(self.audioPlayerNode.isPlaying)")
            //print("engineRunning: \(self.audioEngine.isRunning)")
            //print("volume: \(self.audioPlayerNode.volume)")
        }
    }
}

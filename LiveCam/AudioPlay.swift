////
////  AudioPlay.swift
////  LiveCam
////
////  Created by Developer 1 on 25/10/2024.
////
//
//import Foundation
//import AVFoundation
//import Accelerate
//
//class AudioPlayerManager {
//    var audioEngine = AVAudioEngine()
//    var audioPlayerNode = AVAudioPlayerNode()
//    var isPlayingAudio = false
//
//    init() {
//        setupAudioEngine()
//    }
//
//    private func setupAudioEngine() {
//        // Thiết lập định dạng âm thanh
//        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
//
//        // Kết nối audio node vào audio engine
//        audioEngine.attach(audioPlayerNode)
//        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
//
//        do {
//            try audioEngine.start()
//            isPlayingAudio = true
//        } catch {
//            print("Không thể khởi động audio engine: \(error)")
//            isPlayingAudio = false
//        }
//    }
//
//    // Hàm nhận và giải mã buffer audio từ camera
//    func onCameraManagerReceiveAudioData(_ buffer: UnsafeMutablePointer<Int8>, _ length: Int) {
//        guard length > 0, audioEngine.isRunning, audioPlayerNode.isPlaying || isPlayingAudio else { return }
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            let data = Data(bytes: buffer, count: length)
//            let int16s = data.withUnsafeBytes { (bytes: UnsafePointer<Int16>) -> [Int16] in
//                Array(UnsafeBufferPointer(start: bytes, count: length / MemoryLayout<Int16>.size))
//            }
//
//            let bufferSize = 1024 // Kích thước mỗi đoạn âm thanh xử lý một lần
//            let arrayChunks = int16s.chunked(into: bufferSize)
//
//            DispatchQueue.main.async {
//                arrayChunks.forEach { audioData in
//                    guard !audioData.isEmpty else { return }
//                    let pcmBuffer = self.getPcmFloat32Buffer(audioData, bufferSize: bufferSize)
//                    self.playAudio(pcmBuffer)
//                }
//            }
//        }
//    }
//
//    // Hàm chuyển đổi Int16 sang Float32 và tạo AVAudioPCMBuffer
//    func getPcmFloat32Buffer(_ bytesInt16: [Int16], bufferSize: Int) -> AVAudioPCMBuffer {
//        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
//
//        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(bufferSize)) else {
//            fatalError("Không thể tạo AVAudioPCMBuffer")
//        }
//
//        let monoChannel = buffer.floatChannelData![0]
//        var byteDataFloat32 = [Float32](repeating: 0.0, count: bufferSize)
//        var scale = Float(Int16.max) + 1.0
//
//        // Chuyển đổi từ Int16 sang Float32
//        vDSP_vflt16(bytesInt16, 1, &byteDataFloat32, 1, vDSP_Length(bufferSize))
//        vDSP_vsdiv(byteDataFloat32, 1, &scale, &byteDataFloat32, 1, vDSP_Length(bufferSize))
//
//        // Sao chép dữ liệu vào AVAudioPCMBuffer
//        memcpy(monoChannel, byteDataFloat32, bufferSize * MemoryLayout<Float32>.size)
//        buffer.frameLength = UInt32(bufferSize)
//
//        return buffer
//    }
//
//    // Hàm phát âm thanh từ AVAudioPCMBuffer
//    func playAudio(_ pcmBuffer: AVAudioPCMBuffer) {
//        if !audioPlayerNode.isPlaying {
//            audioPlayerNode.play()
//        }
//        audioPlayerNode.scheduleBuffer(pcmBuffer, at: nil, options: .interrupts, completionHandler: nil)
//    }
//}
//
//// Hàm chia nhỏ mảng thành từng đoạn
//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//        stride(from: 0, to: count, by: size).map {
//            Array(self[$0..<Swift.min($0 + size, count)])
//        }
//    }
//}

//
//import Foundation
//import AVFoundation
//import Accelerate
//
//class AudioPlayerManager {
//    var audioEngine = AVAudioEngine()
//    var audioPlayerNode = AVAudioPlayerNode()
//    var isPlayingAudio = false
//
//    init() {
//        setupAudioEngine()
//    }
//
//    private func setupAudioEngine() {
//        // Thiết lập định dạng âm thanh
//        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
//
//        // Kết nối audio node vào audio engine
//        audioEngine.attach(audioPlayerNode)
//        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
//
//        do {
//            try audioEngine.start()
//            isPlayingAudio = true
//        } catch {
//            print("Không thể khởi động audio engine: \(error)")
//            isPlayingAudio = false
//        }
//    }
//
//    // Hàm nhận và giải mã buffer audio từ camera
//    func onCameraManagerReceiveAudioData(_ buffer: UnsafeMutablePointer<Int8>, _ length: Int) {
//        guard length > 0, audioEngine.isRunning, audioPlayerNode.isPlaying || isPlayingAudio else { return }
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            let data = Data(bytes: buffer, count: length)
//            let int16s = data.withUnsafeBytes { (bytes: UnsafePointer<Int16>) -> [Int16] in
//                Array(UnsafeBufferPointer(start: bytes, count: length / MemoryLayout<Int16>.size))
//            }
//
//            let bufferSize = 1024 // Kích thước mỗi đoạn âm thanh xử lý một lần
//            let arrayChunks = int16s.chunked(into: bufferSize)
//
//            DispatchQueue.main.async {
//                arrayChunks.forEach { audioData in
//                    guard !audioData.isEmpty else { return }
//                    let pcmBuffer = self.getPcmFloat32Buffer(audioData, bufferSize: bufferSize)
//                    self.playAudio(pcmBuffer)
//                }
//            }
//        }
//    }
//
//    // Hàm chuyển đổi Int16 sang Float32 và tạo AVAudioPCMBuffer
//    // Hàm chuyển đổi Int16 sang Float32 và tạo AVAudioPCMBuffer
//    func getPcmFloat32Buffer(_ bytesInt16: [Int16], bufferSize: Int) -> AVAudioPCMBuffer {
//        // Lấy định dạng âm thanh từ audioPlayerNode
//        let audioFormat = audioPlayerNode.outputFormat(forBus: 0)
//
//        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(bufferSize)) else {
//            fatalError("Không thể tạo AVAudioPCMBuffer")
//        }
//
//        let monoChannel = buffer.floatChannelData![0]
//        var byteDataFloat32 = [Float32](repeating: 0.0, count: bufferSize)
//        var scale = Float(Int16.max) + 1.0
//
//        // Chuyển đổi từ Int16 sang Float32
//        vDSP_vflt16(bytesInt16, 1, &byteDataFloat32, 1, vDSP_Length(bufferSize))
//        vDSP_vsdiv(byteDataFloat32, 1, &scale, &byteDataFloat32, 1, vDSP_Length(bufferSize))
//
//        // Sao chép dữ liệu vào AVAudioPCMBuffer
//        memcpy(monoChannel, byteDataFloat32, bufferSize * MemoryLayout<Float32>.size)
//        buffer.frameLength = UInt32(bufferSize)
//
//        return buffer
//    }
//
//    // Hàm phát âm thanh từ AVAudioPCMBuffer
//    func playAudio(_ pcmBuffer: AVAudioPCMBuffer) {
//        if !audioPlayerNode.isPlaying {
//            audioPlayerNode.play()
//        }
//        audioPlayerNode.scheduleBuffer(pcmBuffer, at: nil, options: .interrupts, completionHandler: nil)
//    }
//}
//
//// Hàm chia nhỏ mảng thành từng đoạn
//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//        stride(from: 0, to: count, by: size).map {
//            Array(self[$0..<Swift.min($0 + size, count)])
//        }
//    }
//}
import AVFoundation
import Accelerate

class AudioPlayerManager {
    var audioEngine = AVAudioEngine()
    var audioPlayerNode = AVAudioPlayerNode()
    var audioFormat: AVAudioFormat
    var isPlayingAudio = false

    init() {
        // Thiết lập định dạng âm thanh, với sample rate là 44100 Hz và 1 channel (mono)
        self.audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        
        // Thiết lập Audio Engine và Audio Player Node
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        
        do {
            try audioEngine.start()
            isPlayingAudio = true
        } catch {
            print("Không thể khởi động audio engine: \(error)")
            isPlayingAudio = false
        }
    }
}

extension AudioPlayerManager {
    
    func playAudioData(buffer: UnsafePointer<Int8>, bufferLength: Int) {
        guard bufferLength > 1, bufferLength % 2 == 0 else { return }  // Đảm bảo bufferLength là số chẵn
        
        // Chuyển dữ liệu Int8 thành mảng Int16
        let int16Buffer = UnsafeBufferPointer(start: UnsafeRawPointer(buffer).bindMemory(to: Int16.self, capacity: bufferLength / 2), count: bufferLength / 2)
        let int16Array = Array(int16Buffer)
        
        // Chia nhỏ dữ liệu thành các đoạn có kích thước cố định để phát
        let bufferSize = 1024
        let chunks = int16Array.chunked(into: bufferSize)
        
        chunks.forEach { chunk in
            guard !chunk.isEmpty else { return }
            if let pcmBuffer = convertToPCMBuffer(chunk) {
                playPCMBuffer(pcmBuffer)
            }
        }
    }
    
    private func convertToPCMBuffer(_ samples: [Int16]) -> AVAudioPCMBuffer? {
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(samples.count)) else {
            print("Không thể tạo AVAudioPCMBuffer.")
            return nil
        }
        
        let floatChannelData = buffer.floatChannelData![0]
        var floatSamples = [Float](repeating: 0.0, count: samples.count)
        var scale = Float(Int16.max)
        
        // Chuyển đổi từ Int16 sang Float32 để dùng với AVAudioPCMBuffer
        vDSP_vflt16(samples, 1, &floatSamples, 1, vDSP_Length(samples.count))
        vDSP_vsdiv(floatSamples, 1, &scale, &floatSamples, 1, vDSP_Length(samples.count))
        
        memcpy(floatChannelData, floatSamples, samples.count * MemoryLayout<Float>.size)
        buffer.frameLength = AVAudioFrameCount(samples.count)
        
        return buffer
    }
    
    private func playPCMBuffer(_ buffer: AVAudioPCMBuffer) {
        if !audioPlayerNode.isPlaying {
            audioPlayerNode.play()
        }
        audioPlayerNode.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

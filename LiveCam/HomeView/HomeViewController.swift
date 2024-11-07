//
//  HomeViewController.swift
//  LiveCam
//
//  Created by Developer 1 on 24/10/2024.
//

import UIKit
import KHJCameraLib
import AVFoundation
import AVFAudio
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewCamera: OpenGLView20!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var buttonQualityVideo: UIButton!
    
    private let openGLView = OHCamViewport()
    private let instanceID: Int32 = 207174 // ID của camera
    private let cameraUID: String = "VNTTA-001321-FNJBF"
    private let password: String = "mGxvvngG"
    
    var uid: String?
    var pass: String?
    
    let manager = OHCamSDKApi.sharedInstance()
    var sessionHandle: Int32?
    var isAudioEnabled = false
    var currentQualityMode: Int = 0
    let threadCallAPI               = DispatchQueue(label: "\(Constant.threadNamePrefix).VNPTCameraSessionAction.threadCallApi", attributes: .concurrent)
    var wasAudioEnabledBeforeCall = false
    var timerStartSendAudio             : Timer?
    var timerStopSendAudio              : Timer?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.resultCb_i_Response = self.resultCb_i_Response
        self.manager.resultCb_Response = self.resultCb_Response
        self.manager.videoResponse = self.videoResponse
        self.manager.audioResponse = self.audioResponse
        self.manager.setVideoCallback()
        self.manager.setAudioCallback()
        
        connectCamera()
        setupOpenGLView()
        
        CoreMediaService.shared
            .rxAudioMicroResponse
            .asObserver()
//            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (response) in
                guard
                    let `self` = self
                else { return }
                var _response   = response
        
                print("==> Sending audio \(response.count)")
      
                self.threadCallAPI.async {
                    self.manager.sendAudio(self.sessionHandle ?? 1, &_response, Int32(_response.count), 1, {result in
                        print("Ket qua 1234 \(result)")
                    })
                }
            })
            .disposed(by: self.disposeBag)

       self.micButton.rx.controlEvent([.touchDown])
            .filter{[weak self] _ in
                if AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted {
                    return true
                }
                return false
            }
            .flatMapLatest { [weak self] _ in
                return Observable<Int>.interval(DispatchTimeInterval.milliseconds(0), scheduler: MainScheduler.instance)
                .take(1)}.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.timerStartSendAudio?.invalidate()
                self.timerStopSendAudio?.invalidate()

                self.timerStartSendAudio = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                    self?.call(isCall: true)
                })
            }).disposed(by: self.disposeBag)

        let callup = self.micButton.rx.controlEvent([.touchUpInside, .touchUpOutside])
            .filter { return AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted }
            .flatMapLatest { _ in Observable<Int>.interval(DispatchTimeInterval.milliseconds(0), scheduler: MainScheduler.instance).take(1)}.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.timerStartSendAudio?.invalidate()
                self.timerStopSendAudio?.invalidate()

                self.timerStopSendAudio = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
                    self?.call(isCall: false)
                })
            }).disposed(by: self.disposeBag)

    }
    
    func audioResponse(sessionID: Int32, buffer: UnsafeMutablePointer<Int8>, bufferLength: Int32, seq: Int32, timestamp: Int32) {
            //print("Received audio response - SessionID: \(sessionID), Buffer: \(buffer), BufferLength: \(bufferLength), Seq: \(seq), Timestamp: \(timestamp)")

        CoreMediaService.shared.onCameraManagerReceiveAudioData(buffer, Int(bufferLength))
        }
    
    func videoResponse(sessionID: Int32, avFrame: UnsafeMutablePointer<AVFrame>, frameLength: Int32, seq: Int32, timeStamp: Int32) {
    
           // let width = avFrame.pointee.width
           // let height = avFrame.pointee.height
       // print("Received video response - SessionID: \(sessionID), Frame Size: \(width)x\(height), Frame Length: \(frameLength), Sequence: \(seq), Timestamp: \(timeStamp)")
        let avFrame = avFrame.pointee
        guard
              let yBuffer = avFrame.data.0,
              let uBuffer = avFrame.data.1,
              let vBuffer = avFrame.data.2,
              let view = self.viewCamera,
              yBuffer.pointee != 0,
              uBuffer.pointee != 0,
              vBuffer.pointee != 0  else { return; }
        
        DispatchQueue.main.async {
            view.setVideoSize(UInt32(avFrame.width), height: UInt32(avFrame.height))
            view.displayYUV420pData(yBuffer, andU: uBuffer, andV: vBuffer, width: Int(avFrame.width), height: Int(avFrame.height))
            self.openGLView.vIndicator.isHidden = true
        }
        
    }

    func resultCb_Response(param1: Int32, param2: Int32, param3: Int32) {
               
               print("Received response 2 - Param1: \(param1), Param2: \(param2), Param3: \(param3)")
           }
    
    func resultCb_i_Response(param1: Int32, param2: Int32, param3: Int32, param4: Int32) {
        self.sessionHandle = param1
            print("Received response - Param1: \(param1), Param2: \(param2), Param3: \(param3), Param4: \(param4)")
        if let sessionHandle = self.sessionHandle, sessionHandle > 0 {
                    startStreamingVideo(sessionHandle: sessionHandle)
                    startStreamingAudio(sessionHandle: sessionHandle)
                } else {
                    print("Session handle không hợp lệ, không thể bắt đầu streaming.")
                }
        }
    
    private func setupOpenGLView() {
        openGLView.frame = viewCamera.bounds
        openGLView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewCamera.addSubview(openGLView)
    }
    
    private func connectCamera() {
        manager.initApi("EBGFFBBNKGJEGIJCEDHJFEEMHKNADCJIGGBNBDCAAGNGKGOMDKBDHNOMCFKNNNLAFKMBOEDHPLJDAJCHNDJJIPEKMHPGAMHOBKGICGAHIJOABFGNBJAIOMIJDMILEBCDFBFD:vnptT@12")
        
        manager.connectCamera(
            instanceID,
            cameraUID,
            password,
            "0x7E",
            { result in
                print("Kết quả kết nối: \(result)")
                if result == 0{
                    print("Kết nối thành công")
                } else {
                    print("Loi ket noi")
                }
            }
        )
    }
    
    private func startStreamingVideo(sessionHandle: Int32) {
        manager.startRecvVideo(
            sessionHandle,
            true,
            { result in
            if result == 0 {
                print("Nhận video thành công")
            } else {
                print("Lỗi khi nhận video: \(result)")
            }
        })
    }
    private func startStreamingAudio(sessionHandle: Int32) {
        manager.startRecvAudio(
            sessionHandle,
            true,
            { result in
            if result == 0 {
                print("Nhận audio thành công")
            } else {
                print("Lỗi khi nhận Audio: \(result)")
            }
        })
    }
    
    @IBAction func tapOnAudio(_ sender: Any) {
        isAudioEnabled.toggle()
                
        if isAudioEnabled {
            audioButton.setTitle("", for: .normal)
            CoreMediaService.shared.isPlayAudio(true)
            CameraManager.shared.isPlayRecvAudio(true)
            self.audioButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        } else {
            audioButton.setTitle("", for: .normal)

            CoreMediaService.shared.isPlayAudio(false)
            CameraManager.shared.isPlayRecvAudio(false)
            self.audioButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        }
        
    }
    
    @IBAction func startCall(_ sender: Any) {
            guard AVAudioSession.sharedInstance().recordPermission == .granted else {
                return
            }
            
            wasAudioEnabledBeforeCall = isAudioEnabled
            if isAudioEnabled {
                isAudioEnabled = false
                CoreMediaService.shared.isPlayAudio(false)
                CameraManager.shared.isPlayRecvAudio(false)
                audioButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
            }
            
//            CoreMediaService.shared.isPlayAudio(true)
//            CameraManager.shared.isPlayRecvAudio(true)
            CoreMediaService.shared.onCameraTWAControlbyState(.recording) { isSuccess in
                print("Kết quả: \(isSuccess)")

                if isSuccess {
                    print("Bắt đầu gửi âm thanh đến camera")
                    self.threadCallAPI.async {
                        
                        self.manager.startRecvAudio(self.sessionHandle ?? 1, false) { result in
                            print("Dừng luồng audio: \(result)")
                        }
                        self.manager.startSendAudio(self.sessionHandle ?? 1, true) { result in
                            print("Kết quả gửi âm thanh: \(result)")
                        }
                        
                        DispatchQueue.main.async {
                            self.micButton.setImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
                        }
                    }
                } else {
                    print("Không thể bắt đầu gửi âm thanh")
                }
            }

    }
    @IBAction func stopCall(_ sender: Any) {
        // Dừng gửi âm thanh khi ngừng cuộc gọi
//            CoreMediaService.shared.isPlayAudio(false)
//            CameraManager.shared.isPlayRecvAudio(false)
            manager.startSendAudio(sessionHandle ?? 1, false) { result in
                print("Dừng gửi âm thanh: \(result)")
            }
            manager.startRecvAudio(self.sessionHandle ?? 1, true) { result in
                print("Bật lại luồng audio: \(result)")
            }
            
            if wasAudioEnabledBeforeCall {
                isAudioEnabled = true
                CoreMediaService.shared.isPlayAudio(true)
                CameraManager.shared.isPlayRecvAudio(true)
                audioButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
            }
            
            self.micButton.setImage(UIImage(systemName: "mic.slash.circle.fill"), for: .normal)
    }

    func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("Quyền truy cập micro đã được cấp.")
            // Thực hiện các thao tác sử dụng micro
        case .denied:
            print("Quyền truy cập micro đã bị từ chối.")
            // Hướng dẫn người dùng cấp quyền trong phần Cài đặt
        case .undetermined:
            print("Quyền truy cập micro chưa được hỏi.")
            // Yêu cầu quyền truy cập micro
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("Người dùng đã cấp quyền truy cập micro.")
                } else {
                    print("Người dùng đã từ chối quyền truy cập micro.")
                }
            }
        @unknown default:
            print("Trạng thái không xác định.")
        }
    }
    
    @IBAction func tapStop(_ sender: Any) {
        manager.initApi("EBGFFBBNKGJEGIJCEDHJFEEMHKNADCJIGGBNBDCAAGNGKGOMDKBDHNOMCFKNNNLAFKMBOEDHPLJDAJCHNDJJIPEKMHPGAMHOBKGICGAHIJOABFGNBJAIOMIJDMILEBCDFBFD:vnptT@12")
        
        manager.reconnectCamera(
                    instanceID,
                    cameraUID,
                    password,
                    "0x7E",
                    { result in
                        print("Kết quả kết nối lại: \(result)")
                        if result == 0{
                            print("Kết nối lại thành công")
                } else {
                    print("Loi ket noi lai")
                }
            }
        )
    }
    
    @IBAction func tapQualityVideo(_ sender: Any) {
        currentQualityMode = (currentQualityMode == 0) ? 1 : 0
                
                
        manager.setVideoQuality(sessionHandle ?? 1, Int32(currentQualityMode), -1) { result in
                    let quality = self.currentQualityMode == 0 ? "HD" : "SD"
                    print("Chất lượng video đã thay đổi thành \(quality): \(result)")
            self.buttonQualityVideo.setTitle(quality, for: .normal)
            }
        
    }
    
    @IBAction func tapTopPtz(_ sender: Any) {
        manager.setRun(sessionHandle ?? 1, -1, -1, 1, -1, {result in
            print("Kết quả xoay trên \(result)")
        })
    }
    
    @IBAction func tapBottomptz(_ sender: Any) {
        manager.setRun(sessionHandle ?? 1, -1, -1, -1, 1, {result in
            print("Kết quả xoay dưới \(result)")
        })
    }
    @IBAction func tapLeftPtz(_ sender: Any) {
        manager.setRun(sessionHandle ?? 1, 1, -1, -1, -1, {result in
            print("Kết quả xoay trái \(result)")
        })
    }
    
    @IBAction func tapRightPtz(_ sender: Any) {
        manager.setRun(sessionHandle ?? 1, -1, 1, -1, -1, {result in
            print("Kết quả xoay phải \(result)")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CoreMediaService.shared.setupAudioSession()
        CoreMediaService.shared.initializedAudio()
        CoreMediaService.shared.initialzedTWA()
        super.viewWillAppear(animated)
        
    }
    
    private func call(isCall: Bool) {
        if isCall {
            wasAudioEnabledBeforeCall = isAudioEnabled
            if isAudioEnabled {
                isAudioEnabled = false
                CoreMediaService.shared.isPlayAudio(false)
                CameraManager.shared.isPlayRecvAudio(false)
                audioButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
            }
            if AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted {
                //CoreMediaService.shared.isPlayAudio(true)
                //CameraManager.shared.isPlayRecvAudio(true)
                CoreMediaService.shared.onCameraTWAControlbyState(.recording) { isSuccess in
                    print("Kết quả: \(isSuccess)")

                    if isSuccess {
                        print("Bắt đầu gửi âm thanh đến camera")
                        self.threadCallAPI.async {
                        
                            self.manager.startRecvAudio(self.sessionHandle ?? 1, false) { result in
                                print("Dừng luồng audio: \(result)")
                            }
                            
                            self.manager.startSendAudio(self.sessionHandle ?? 1, true) { result in
                                print("Kết quả gửi âm thanh: \(result)")
                            }
                            
                            DispatchQueue.main.async {
                                self.micButton.setImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
                            }
                        }
                    } else {
                        print("Không thể bắt đầu gửi âm thanh")
                    }
                }
                return
            }
        } else {
            
            CoreMediaService.shared.onCameraTWAControlbyState(.paused) { [weak self] (isSuccess) in
                guard let `self` = self else { return }
                if !isSuccess {
                    print("Stop errror")
                    return
                }
                
                self.threadCallAPI.async {
                    self.manager.startSendAudio(self.sessionHandle ?? 1, false) { result in
                        print("Dừng gửi âm thanh: \(result)")
                    }
                    self.manager.startRecvAudio(self.sessionHandle ?? 1, true) { result in
                        print("Bật lại luồng audio: \(result)")
                    }
                    DispatchQueue.main.async {
                        self.micButton.setImage(UIImage(systemName: "mic.slash.circle.fill"), for: .normal)
                    }
                }
            }
            if wasAudioEnabledBeforeCall {
                isAudioEnabled = true
                CoreMediaService.shared.isPlayAudio(true)
                CameraManager.shared.isPlayRecvAudio(true)
                audioButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
            }
        }
    }
}

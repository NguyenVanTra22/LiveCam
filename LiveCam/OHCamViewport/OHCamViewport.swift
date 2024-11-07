//
//  VNPTCamViewport.swift
//  OneHome
//
//  Created by ThiemJason on 16/03/2022.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

import UIKit
import KHJCameraLib
import NVActivityIndicatorView
import RxSwift
import RxCocoa

protocol VNPTCamViewportDelegate: NSObjectProtocol {
    
}

enum VNPTCamViewportMode {
    case LiveView
    case PlaybackSDCard
    case PlaybackCloud
}

class OHCamViewport: UIView {
    /** Super view */
    @IBOutlet var mainView                          : UIView!
    
    /** vCameraViewport */
    @IBOutlet weak var vCameraViewport              : UIView!
    @IBOutlet weak var vCameraView                  : UIView!
    @IBOutlet weak var lblTimeCountingLS            : UILabel!
    @IBOutlet weak var vWrapperTimeCountingLS       : UIView!
    @IBOutlet weak var vWrapperNetworkLS            : UIView!
    @IBOutlet weak var lblNetworkCountingLS         : UILabel!
    @IBOutlet weak var lblWaterMark                 : UILabel!
    @IBOutlet weak var scvSrollView                 : UIScrollView!
    @IBOutlet weak var imgUnderOpenGLView           : UIImageView!
    @IBOutlet weak var imgAboveOpenGLView           : UIImageView!
    @IBOutlet weak var vOpenGLView                  : OpenGLView20!
    
    // vCamera
    @IBOutlet weak var vCamera                      : UIView!
    @IBOutlet weak var imgCameraSnapshot            : UIImageView!
    
    // vCameraPlaceholder
    @IBOutlet weak var vCameraPlaceholder           : UIView!
    @IBOutlet weak var vBlackBackground             : UIView!
    @IBOutlet weak var vIndicator                   : NVActivityIndicatorView!
    @IBOutlet weak var vCameraStatus                : UIView!
    @IBOutlet weak var btnCameraStatus              : UIButton!
    @IBOutlet weak var lblCameraStatus              : UILabel!
    
    // MARK: Rx propery
    private var disposeBag                          = DisposeBag()
    var rxCameraState                               = BehaviorRelay<CameraManager.CameraState>(value: .Connect)
//    var rxDevice                                    = BehaviorRelay<Device?>(value: nil)
    var rxCamViewportMode                           = BehaviorRelay<VNPTCamViewportMode>(value: .LiveView)
    
    // MARK: - Property
    weak var delegate                               : VNPTCamViewportDelegate?
    
    // MARK: Setting UI View
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializedView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializedView()
    }
}

// MARK: - UI Configuration
extension OHCamViewport {
    /** Init view */
    private func initializedView() {
        Bundle.main.loadNibNamed("OHCamViewport", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.mainView.frame = self.bounds
        self.mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.vIndicator.startAnimating()
        
        self.scvSrollView.delegate = self
        self.setupLocalized()
        self.setupBinding()
        
        self.vWrapperTimeCountingLS.layer.cornerRadius  = 10
        self.vWrapperTimeCountingLS.clipsToBounds       = true
        
        self.vWrapperNetworkLS.layer.cornerRadius       = 10
        self.vWrapperNetworkLS.clipsToBounds            = true
    }
    
    private func setupLocalized() {
        
    }
    
    private func setupTheme() {
        
    }
    
    /** Auto layout */
    private func setupAutoLayout( isLandscape landscape : Bool? = nil ) {
        let isLandscape =  landscape ?? UIApplication.shared.statusBarOrientation.isLandscape
        if isLandscape {
            self.setupViewLanscape()
        } else {
            self.setupViewPortrait()
        }
    }
    
    private func setupViewPortrait() {
        
    }
    
    private func setupViewLanscape() {
        
    }
}

// MARK: - UI Observing
extension OHCamViewport {
    /** updateUIbyCameraState */
    private func updateUICameraByState(_ cameraState: CameraManager.CameraState) {
        switch cameraState {
        case .Connect:
            self.updateUIWhenCameraConnecting()
        case .Sleep:
            self.updateUIWhenCameraSleep()
        case .Offline:
            self.updateUIWhenCameraOffline()
        case .LiveView:
            self.updateUIWhenCameraLiveView()
        case .VideoRecord:
            self.updateUIWhenCameraVideoRecoring()
        case .AudioCall:
            self.updateUIWhenCameraAudioCalling()
        case .UpdateFirmware:
            self.updateUIWhenCameraUpdateFirmware()
        case .StopPlayback:
            self.updateUIWhenCameraStopPlayback()
        case .NoneVideo:
            self.updateUIWhenCameraNoneVideo()
        default:
            break
        }
    }
    
    /** (Enable - Disable) all button quickly */
    private func toggleAllButtonState(isEnable : Bool) {
        // Portrait button
    }
    
    /** STOP - PLAY BACK*/
    /** Không làm gì cả */
    private func updateUIWhenCameraStopPlayback() {
        self.toggleAllButtonState(isEnable: false)
    }
    
    /** UPDATE-FIRMWARE */
    /** TODO: Show updatefimware viewport cameraplaceholder.  Disable all button */
    private func updateUIWhenCameraUpdateFirmware() {
        self.toggleAllButtonState(isEnable: false)
        self.btnCameraStatus.setImage(UIImage(named: "ic_warning"), for: .normal)
//        self.lblCameraStatus.text = OHText.OHCam.Setting.Connection.updating
    }
    
    /** SLEEP */
    /** TODO: Show sleep viewport cameraplaceholder, enable btnSetting, btnNoti, btnPlayback. Disable all button else */
    private func updateUIWhenCameraSleep() {
        self.toggleAllButtonState(isEnable: false)
        self.btnCameraStatus.setImage(UIImage(named: "ic_sleep_mode"), for: .normal)
//        self.lblCameraStatus.text = dLocalized("KEY_LBL_CAMERA_SLEEP_MODE")
    }
    
    /** OFFLINE */
    /** TODO: Show offline viewport cameraplaceholder, enable btnNoti, btnPlayback, btnSetting, btnZoom */
    private func updateUIWhenCameraOffline() {
        self.toggleAllButtonState(isEnable: false)
        self.btnCameraStatus.setImage(UIImage(named: "ic_reload"), for: .normal)
//        self.lblCameraStatus.text = dLocalized("KEY_LBL_CAMERA_CONNECT_FAIL")
    }
    
    /** LIVE-VIEW */
    /** Hide viewport placeholder, enable allbutton */
    private func updateUIWhenCameraLiveView() {
        self.toggleAllButtonState(isEnable: true)
    }
    
    /** CONNECTING */
    /** TODO: Show loading indicator, show snapshot if exist, disable all button */
    private func updateUIWhenCameraConnecting() {
        self.toggleAllButtonState(isEnable: false)
    }
    
    /** VIDEO-RECORDING */
    /** TODO: Show timer counting, enable btnVideoRecord, disable all button else */
    private func updateUIWhenCameraVideoRecoring() {
        self.toggleAllButtonState(isEnable: false)
    }
    
    /** AUDIO-CALLING */
    /**: Show timer counting, enable btnCalling, disable all button else */
    private func updateUIWhenCameraAudioCalling() {
        self.toggleAllButtonState(isEnable: false)
    }
    
    /** NONE-Video */
    /**: Show timer counting, enable btnCalling, disable all button else */
    private func updateUIWhenCameraNoneVideo() {
        self.toggleAllButtonState(isEnable: false)
    }
}

// MARK: - UIScrollViewDelegate
extension OHCamViewport: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.vOpenGLView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if self.scvSrollView.zoomScale == 1.0 {
            self.scvSrollView.isScrollEnabled = false
            self.scvSrollView.setContentOffset(.zero, animated: true)
        }else{
            self.scvSrollView.isScrollEnabled = true
        }
    }
}


// MARK: - Logic implementaion
extension OHCamViewport {
    private func setupBinding() {
//        self.rxDevice.asDriver().compactMap{ $0 }.drive ( onNext: { [weak self] (device) in
//            guard let `self` = self else { return }
//            /** Water mark  */
//            let watermark_mode                  = device.configs?.watermark_mode ?? "off"
//            self.lblWaterMark.text              = watermark_mode == "on" ? device.configs?.watermark_text ?? "" : ""
//            self.lblWaterMark.isHidden          = watermark_mode == "off"
//        }).disposed(by: self.disposeBag)
        
        self.rxCameraState.asDriver().drive (onNext: { [weak self] (state) in
            guard let `self` = self else { return }
            /** Update camera state UI */
            self.updateUICameraByState(state)
            
            /** Cần binding như này dể khi Camera state thay đổi, bộ đếm thời gian sẽ bị ẩn */
            /** Video record */
            self.vWrapperTimeCountingLS.isHidden = true
            if [.VideoRecord, .AudioCall].contains(state) {
                /// Luôn hiển thị nếu playbackMode đang là `Cloud` `SDCard`
                if [.PlaybackSDCard, .PlaybackCloud].contains(self.rxCamViewportMode.value) {
                    self.vWrapperTimeCountingLS.isHidden = false
                } else {
                    /// Chỉ hiển thị khi màn hình xoay ngang
                    self.vWrapperTimeCountingLS.isHidden = !UIApplication.shared.statusBarOrientation.isLandscape
                }
            }
            
            /** Connect + Sleep + Offline */
            self.vIndicator.isHidden = !(state == .Connect)
            self.vBlackBackground.isHidden = !(state == .Sleep)
            self.vCameraPlaceholder.isHidden = ![.Sleep, .Offline, .Connect, .NoneVideo, .UpdateFirmware].contains(state)
            self.btnCameraStatus.isHidden = ![.Sleep, .Offline, .UpdateFirmware].contains(state)
            self.lblCameraStatus.isHidden = ![.Sleep, .Offline, .UpdateFirmware].contains(state)
            self.btnCameraStatus.isUserInteractionEnabled = state == .Offline
            
            let insetDimension = isPad ? 10.0 : 6.0
            let offlineImageInset = UIEdgeInsets(top: insetDimension, left: insetDimension, bottom: insetDimension, right: insetDimension)
            let originalImageInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.btnCameraStatus.imageEdgeInsets = (state == .Offline) ? offlineImageInset : originalImageInset
        }).disposed(by: self.disposeBag)
        
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
//        self.scvSrollView.rx
//            .gesture(doubleTapGesture)
//            .when(.recognized)
//            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] _ in
//                if self?.scvSrollView.zoomScale == 1.0 { return }
//                self?.scvSrollView.zoomScale = 1.0
//                self?.scvSrollView.isScrollEnabled = false
//                self?.scvSrollView.setContentOffset(.zero, animated: true)
//            }).disposed(by: self.disposeBag)
    }
}


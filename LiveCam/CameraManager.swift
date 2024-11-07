//
//  CameraManager.swift
//  OneHome
//
//  Created by Thiem Jason on 15/11/2021.
//  Copyright © 2021 VNPT Technology. All rights reserved.
//

import Foundation
import KHJCameraLib
import RxSwift

class CameraManager {
    
    // MARK: - Constant
    static let PtzRotationStep = 10
    enum PtzRotationType : Int {
        case right  = 3
        case left   = 6
        case up     = 1
        case down   = 2
    }
    
    enum CameraConnectResponseKey : Int {
        case ConnectSuccessful          = 0         /** Kết nối thành công */
        case NotInitialized             = -1        /** Khởi tạo kết nối thất bại */
        case AlreadyInitialized         = -2        /** Đang tồn tại khởi tạo */
        case Timeout                    = -3        /** Kết nối đã quá thời gian timeout */
        case InvalidID                  = -4        /** ID thiết bị không chính xác */
        case InvalidParamss             = -5        /** Tham số truyền không chính xác */
        case Offline                    = -6        /** Thiết bị không kết nối mạng */
        case FailToResolveName          = -7
        case InvalidIDPrefix            = -8        /** UID không phù hợp với máy chủ */
        case IDOutOfDate                = -9
        case InvalidSessionHandle       = -11
        case CameraSessionClosed        = -12       /** Camera đóng phiên kết nôi */
        case SessionClosedTimeout       = -13       /** Phiên kết nối bị timeout */
        case SessionClosedCalled        = -14
        case RemoteSiteBufferFull       = -15
        case UserListenBreak            = -16
        case MaxSpeed                   = -17
        case UDPPortBindFailed          = -18
        case UserConnectBreak           = -19
        case InsufficientMemory         = -20
        case InvalidIdApplicense        = -21
        case FailToCreateThread         = -22
        case FunctionParamsIncorrect    = -20000    /** The incoming parameter of the function is incorrect */
        case AVModuleInitialized        = -20019    /** AV module has not been initialized */
        case AVChannelMaximum           = -20002    /** The number of AV channels has reached the maximum */
        case AVCantCreateThread         = -20004    /** AV cannot create thread */
        case AVServerNotResponse        = -20007    /** The specified AV server is not responding */
        case RemoteSiteClosed           = -20015    /** The remote site is closedg */
        case RemoteSiteDidResponse      = -20016    /** (This session has been disconnected because the remote site did not respond after the specified timeout expired) */
        case AVChannelInValid           = -20010    /** The session of the specified AV channel is invalid) */
        case ClientProcessTerminate     = -20018    /** Client startup process terminated) */
        case OperationsTimeout          = -20011    /** The timeout specified during some operations has expired) */
        case ClientPasswordInvalid      = -20009    /** Client verification failed due to incorrect account or password) */
        case UidNotValid                = -20023    /** UID是精简版UID(UID is a simplified UID) */
        case UidNotLicenced             = -10       /** The specified UID is not licensed or has expired) */
        case NoDeviceFoundOrDeadServer  = -90       /** 所有服务器响应都找不到设备(No device found by any server response) */
    }
    
    static let CameraConnectKeyNeedToReconnect = [
        CameraManager.CameraConnectResponseKey.Timeout.rawValue,
        CameraManager.CameraConnectResponseKey.InvalidIDPrefix.rawValue,
        -5555,
        CameraManager.CameraConnectResponseKey.CameraSessionClosed.rawValue,
        CameraManager.CameraConnectResponseKey.SessionClosedTimeout.rawValue,
        CameraManager.CameraConnectResponseKey.UserConnectBreak.rawValue,
        CameraManager.CameraConnectResponseKey.ClientPasswordInvalid.rawValue
    ]
    
    enum CameraState {
        case UpdateFirmware
        case Connect
        case Sleep
        case Offline
        case LiveView
        case VideoRecord
        case AudioCall
        
        /** Bổ sung trạng thái `Background` để dùng cho playSD card, bởi vì SDCard có một `Loop get video` để lấy file video playback gần nhất */
        case Background
        
        /** Bổ sung trạng thái `NoneView` để dùng cho playSD card, bởi vì khi `NoneVideo`, UI sẽ được hiển thị là `Loading` và `SeekBar` sẽ được dừng ở lúc `12:00 buổi trưa`*/
        case NoneVideo
        
        /** Bổ sung trạng thái `StopPlayback` để dùng cho playSD card, sử dụng để check trạng thái STOP playback video **/
        case StopPlayback
    }
    
    enum CameraConnectType:Int, Codable {
        case Ethernet
        case Wifi
    }
    
    // MARK: - Completion
    typealias CameraInfoCompletion = ((_ allCapacity: Int32,_ leftCapacty: Int32,_ version: Int32,_ model: String?,_ vendor: String?,_ ffs: String? ) -> Void)
    typealias RegisterActivePushListenerCompletion = ((_ cameraType: Int32,_ dString: String?,_ uuidRegStr: String?) -> Void)
    typealias CameraConnectSuccessCompletion = ((_ uuidString: String?,_ successKey : Int) -> Void)
    typealias CameraConnectOfflineCompletion = (() -> Void)
    typealias SuccessCompletion = ((_ isSuccess : Bool) -> Void)
    
    // MARK: - Property
    static let shared = CameraManager()
    private var manager = KHJDeviceManager()
    
    /// `TẠM THỜI` sử dung để detect show popup tương ứng
    var listCameraUsing = Set<String>()
    
    //MARK: - 2.3.2.1 Update force close when camera has been password changed from anthor device using same account
    var isCameraChangePasswordInSetting : String?
    
    let disposeBag = DisposeBag()
    
    // MARK: - Camera connection
    /**
     Camera connection
     @param pwd password
     @param uidStr deviceID
     @param resultBlock resultBlock
     @param offLineBlock offLineBlock
     */
    public func onCameraConnect(_ password: String,
                                _ uuid: String?,
                                _ connectionFlag: Int32 = connectionFlagFastMode,
                                successCallback: @escaping CameraConnectSuccessCompletion,
                                offlineCallback: @escaping CameraConnectOfflineCompletion) {
        self.manager.connect(password, withUid: uuid, flag: connectionFlag) { (uidStr, successKey) in
            successCallback(uidStr, successKey)
        } offLineCallBack: {
            offlineCallback()
        }
    }
    
    /**
     Reconnect device
     @param pwd password
     @param uidStr deviceID
     @param resultBlock resultBlock
     @param offLineBlock offLineBlock
     */
    public func onCameraReconnect(_ password: String,
                                  _ uuid: String?,
                                  _ connectionFlag: Int32 = connectionFlagFastMode,
                                  successCallback: @escaping CameraConnectSuccessCompletion,
                                  offlineCallback: @escaping CameraConnectOfflineCompletion) {
        self.manager.reConnect(password, withUid: uuid, flag: connectionFlag) { (uidStr, successKey) in
            successCallback(uidStr, successKey)
        } offLineCallBack: {
            offlineCallback()
        }
    }
    
    // MARK: - Camera controller
    /**
     Camera destroy self
     */
    public func onCameraDestroySelf() {
        /// `Tạm thời bỏ để thử`
        //        self.manager.destroySelf()
    }
    
    /**
     Disconnect Camera
     */
    public func onCameraDisconnect() {
        self.manager.disconnect()
    }
    
    /**
     Camera direction flip
     */
    public func onCameraDirectionFlip(completion: @escaping (_ : Bool, _ : Bool) -> Void) {
        if self.manager.checkDeviceStatus() == 1 {
            self.manager.getFLipping { [weak self] (isFlipped) in
                self?.manager.setFlippingWithDerect( isFlipped ? 0 : 1 ) { (isSusccess) in
                    completion(isSusccess, !isFlipped)
                }
            }
        }
    }
    
    /**
     Set camera viewport with OpenGL
     */
    public func setCameraOpenGLView(_ openGL20: OpenGLView20 ) {
        self.manager.glView = openGL20
    }
    
    /**
     Get camera viewport with OpenGL
     */
    public func getCameraOpenGLViewSize() -> CGSize {
        guard let _glView = self.manager.glView else { return CGSize(width: 0.0, height: 0.0) }
        return CGSize(width: _glView.frame.width, height: _glView.frame.height)
    }
    
    /**
     Set camera status with open
     */
    public func setCameraStatusWithOpen(_ bool: Bool,
                                        completion: @escaping ((_ : String?,_ : Bool?) -> Void)) {
        self.manager.setDeviceCameraStatusWithOpen(bool) { (uidString, isSuccess) in
            completion(uidString, isSuccess)
        }
    }
    
    /**
     Set camera ptz Rotation
     */
    public func setCameraPtzRotate(_ ptzRotationType : CameraManager.PtzRotationType) {
        if self.manager.checkDeviceStatus() == 1 {
            switch ptzRotationType {
                case .right:
                    OHEventTracking.shared.log(.camPtzRightClicked(modelCode: Constant.DeviceType.camera176.rawValue))
                case .left:
                    OHEventTracking.shared.log(.camPtzLeftClicked(modelCode: Constant.DeviceType.camera176.rawValue))
                case .up:
                    OHEventTracking.shared.log(.camPtzUpClicked(modelCode: Constant.DeviceType.camera176.rawValue))
                case .down:
                    OHEventTracking.shared.log(.camPtzDownClicked(modelCode: Constant.DeviceType.camera176.rawValue))
            }
            self.manager.setRun(ptzRotationType.rawValue , withStep: CameraManager.PtzRotationStep )
        }
    }
    
    /**
     Set camera base
     */
    public func setCameraBase(_ cameraToken: String,
                              _ keyword: String ) {
        self.manager.creatCameraBase(cameraToken, keyword: keyword)
    }
    
    /** Set video record type
     Turn off recording, continuous recording, timing planning, alarm recording
     */
    public func setCameraVideoRecordType(_ type: Int32,
                                         completion: @escaping SuccessCompletion) {
        self.manager.setVideoRecordType(type) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Set device new password
     @param oldpassword device old password
     @param newpassword device new password
     @param uidStr device id
     */
    public func setCameraPassword(_ oldpassword: String,
                                  _ newPassword: String,
                                  _ uuid: String,
                                  completion: @escaping SuccessCompletion) {
        self.manager.setPassword(oldpassword, newpassword: newPassword, withUid: uuid) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Set the device alarm address, call this address when an alarm is triggered
     */
//    public func setCameraPHPServer(_ domain: String = Constant.Router.domain,
//                                   completion: @escaping ((_ : Bool, _ : String?) -> Void)) {
//        self.manager.setphpserver(domain) { (isSuccess, url) in
//            completion(isSuccess, url)
//        }
//    }
    
    /**
     Set time zone
     @param timezone time zone
     - " -660 -600 -540 -480 -420 -360 -300 -240 -180 -120 -60 0 60 120 180 240 300 360 420 480 540 600 660 720 ”
     @param resultBlock
     - success true set success, false set failed
     */
    public func setCameraTimezone(_ _timezone: Int,
                                  completion: @escaping SuccessCompletion) {
        self.manager.setTimezone( _timezone) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Set device volume
     @param resultBlock
     - volume volume: 0 - 100
     */
    public func setCameraVolume(_ volumeRate: Int32,
                                completion: @escaping SuccessCompletion) {
        self.manager.setDeviceVolume(volumeRate) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /** Set camera cloud storage
     @param isStart Whether to open cloud storage
     @param type Cloud service type (1 full-day video, 0 alarm recording)
     */
    public func setCameraCloudStorage(_ isStart: Bool,
                                      _ andType: Int32,
                                      completion: @escaping SuccessCompletion) {
        self.manager.setCloundStorage(isStart, andType: andType) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Set the user's picture clarity when recording
     
     @param quality 1: Process, 2: SD, 3: HD
     @param resultBlock
     - success YES setting is successful, NO setting failed
     - (BOOL)setRecordVideoQuality:(int)quality
     returnBlock:(void(^)(BOOL success))resultBlock;
     */
    public func setCameraRecordVideoQuality(_ quality: Int32, completion: @escaping SuccessCompletion) {
        self.manager.setRecordVideoQuality(quality) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    
    /**
     Format SDCard
     @param resultBlock
     - 0: Success
     - -1: Failed
     - -2: No sdcard inserted
     - (void)formatSdcard:(void(^)(int success))resultBlock;
     */
    public func onCameraFormatSDCard(completion: @escaping ((_: Int32) -> Void) ) {
        self.manager.formatSdcard { (responseKey) in
            completion(responseKey)
        }
    }
    
    /**
     Register the status of the listening device
     The device actively pushes the event to the app, event type + event parameter
     @param resultBlock
     - type Type: 0 Device is on 1 Device is off 2 Start recording 3 Stop recording 4 5 Device SD card insertion and playback 6 Video quality switching
     - dString such as: type == 0 type == 1, do not use dString
     Type == 6, will use dString
     - uidStr device id
     */
    public func registerActivePushListener(completion: @escaping RegisterActivePushListenerCompletion ) {
        self.manager.registerActivePushListener { (_cameraType, dString, uuidRegStr) in
            completion(_cameraType, dString, uuidRegStr)
        }
    }
    
    /**
     Un register Camera Active Push listener
     */
    public func unRegisterActivePushListener() {
        self.manager.unregisterActivePushListener()
    }
    
    /**
     Camera quality
     */
    public func setCameraVideoQuality(_ quality: Int,
                                      completion: @escaping SuccessCompletion) {
        self.manager.setVideoQuality(quality == 1 ? 0x01 : 0x05) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Set device alarm sound switch
     
     @param isOpen YES Alarm is on, NO is off
     @param resultBlock
     - success YES setting is successful, NO setting failed
     - (void)setDeviceAlarmVolume:(BOOL)isOpen
     returnBlock:(void(^)(BOOL success))resultBlock;
     */
    public func setCameraAlarmVolumn(_ bool: Bool, completion: @escaping SuccessCompletion) {
        self.manager.setDeviceAlarmVolume(bool) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Start or end recording a video
     @param on Start recording (YES) End recording (NO)
     @param path video save path
     */
    public func startCameraRecordMp4(_ isRecoding: Bool,
                                     _ savePath: String) {
        self.manager.startRecordMp4(isRecoding, path: savePath)
    }
    
    /**
     Camera video controller a
     */
    public func startCameraRecvVideo(_ isReceiveVideo: Bool,
                                     _ cameraUUID : String,
                                     completion: @escaping SuccessCompletion) {
        self.manager.startRecvVideo( isReceiveVideo, withUid: cameraUUID) { (isSuccess) in
            completion(isSuccess)
        }
    }
    
    /**
     Camera audio controller
     */
    public func startCameraRecvAudio(_ isReceiveAudio: Bool ) {
        self.manager.startRecvAudio( isReceiveAudio)
    }
    
    /**
     Camera send audio
     */
    public func startCameraSendAudio(_ isSendAudio: Bool ) {
        self.manager.startSendAudio(isSendAudio)
    }
    
    /**
     Whether to play audio
     */
    public func isPlayRecvAudio(_ isReceiveAudio: Bool ) {
        self.manager.isPlayRecvAudio( isReceiveAudio)
    }
    
    /**
     Get currentCameraManager
     */
    public func getCurrentCameraManager() -> KHJDeviceManager {
        return self.manager
    }
    
    /**
     Get camera video quality
     */
    public func getCameraVideoQuality() -> Int {
        self.manager.getVideoQuality().rawValue
    }
    
    /**
     Get the user's picture clarity when recording
     @param resultBlock
     - level 1: flow 2: standard definition 3: HD
     */
    public func getCameraRecordVideoQuality(completion: @escaping ((_ : Int32) -> Void)) {
        self.manager.getRecordVideoQuality { (resolution) in
            completion(resolution)
        }
    }
    
    /** get camera device info */
    public func getCameraInfo(_ cameraToken: String,
                              completion: @escaping CameraInfoCompletion ) {
        self.manager.queryDeviceInfo(cameraToken) { (allCapacity , leftCapacity, version, model, vendor, ffs) in
            completion(allCapacity, leftCapacity, version, model, vendor, ffs)
        }
    }
    
    /**
     get camera viewport with OpenGL
     */
    public func getCameraOpenGLView() -> OpenGLView20 {
        return self.manager.glView
    }
    
    /**
     Query whether it is currently online
     * 0: Offline 1: Online 2: Connecting
     */
    public func getCameraStatus() -> Int {
        return Int(self.manager.checkDeviceStatus())
    }
    
    /**
     Get current viewers
     
     @param resultBlock
     - num number of viewers
     @return YES Gets success, NO gets failed
     */
    public func getCameraCurrentViewers(completion: @escaping ((_ viewers : Int) -> Void)) {
        self.manager.getCurrentWatchPeoples {(_viewers) in
            completion(Int(_viewers))
        }
    }
    
    /**
     Get device switch status
     
     @param resultBlock
     - uidString device id
     - success error code 0 : Sleep, 1 : LiveView
     */
    public func getDeviceCameraStatus(completion: @escaping (_ uidStr : String?, _ isLiveView : Int) -> Void ) {
        self.manager.getDeviceCameraStatus {(uidString, statusCode) in
            completion(uidString, Int(statusCode))
        }
    }
    
    /** Get timezone */
    public func getTimeZone(completion: @escaping (_ : String) -> Void ) {
        self.manager.getTimeZone { (timeZone) in
            if timeZone >= 0 {
                completion("UTC +" + "\(timeZone/60):\(timeZone % 60)")
            } else {
                completion("UTC " + "\(timeZone/60):\(timeZone % 60)")
            }
        }
    }
    
    /** Get firmware version */
    public func getFirmwareVersion(_ cameraUID : String, completion: @escaping ((_ isSuccess : Bool, _ firmwareVersion: String) -> Void)) {
        self.manager.queryDeviceInfo(cameraUID) { (allCapacity, leftCapacity, version, model, vendor, ffs) in
            if version != 0 {
                let firmwareVersion = version
                let a = firmwareVersion & 0xff
                let b = ( firmwareVersion >> 8 ) & 0xff
                let c = ( firmwareVersion >> 16 ) & 0xff
                completion(true, "\(c).\(b).\(a)")
            }else{
                completion(false, "")
            }
        }
    }
    
    /**
     Get mac and ip
     
     @return
     - success 0 success other failure
     - mac mac address
     - ip ip address
     - (BOOL)getMacIp:(void(^)(int success, NSString *mac, NSString *ip))resultBlock;
     */
    public func getMacIP(completion: @escaping ((_ : Int,_ : String?, _ : String?) -> Void)) {
        self.manager.getMacIp {(success, mac, ip) in
            completion(Int(success), mac, ip)
        }
    }
    
    /**
     Get a timed list of devices "recorded video"
     
     @param resultBlock
     - mArray "recording video" timing list
     - (void)getTimedRecordVideoTask:(void(^)(NSMutableArray *mArray))resultBlock;
     */
    public func getTimeRecordVideoTask(completion: @escaping (_ : NSMutableArray?) -> Void) {
        self.manager.getTimedRecordVideoTask { (array) in
            completion(array)
        }
    }
    
    /**
     Add a scheduled task for "Recording Video" (add all current tasks each time you add it)
     The data format is: "08:30-09:30\n10:00-12:30"
     Between groups and groups, use "\n" to separate up to 85 timed tasks
     
     @param array timer task array
     @param resultBlock
     - success YES success, NO failure
     */
    public func addTimedRecordVideoTask(_ timeInfo: [NSObject], completion: @escaping ((_ : Bool) -> Void)) {
        self.manager.addTimedRecordVideoTask(timeInfo) {(bool) in
            completion(bool)
        }
    }
    
    /**
     Get the current video screen flip status
     
     @param resultBlock
     - success YES has been flipped 180, NO original state
     - (BOOL)getFLipping:(void(^)(BOOL success))resultBlock;
     */
    public func getCameraFlipping(completion: @escaping (_: Bool) -> Void) {
        if self.manager.checkDeviceStatus() == 1 {
            self.manager.getFLipping { (isFlipped) in
                completion(isFlipped)
            }
        }
    }
    
    /**
     Show this popup when camera passwordView has been changed from another device using same account.
     */
//    public func showPopupCameraPasswordChanged(_ cameraName: String) {
//        let message = "\(cameraName) \(dLocalized("KEY_ERROR_CAMERA_CHANGE_PASS_TITLE"))\n\(dLocalized("KEY_ERROR_CAMERA_CHANGE_PASS_BODY"))"
//        
//        let popup = CommonPopup()
//        popup.show()
//        popup.lblTitle.text = OHText.notification
//        popup.lblContent.text = message
//        popup.stvTextField.isHidden = true
//        popup.vLeftBtn.isHidden = true
//        popup.vRightBtn.lblTitle.text = OHText.agree
//
//        popup.vRightBtn.btnAction.rx.tap().subscribe(onNext: { _ in
//            popup.dismiss(animated: true)
//        }).disposed(by: disposeBag)
//        
//    }
    
//    public func handleCameraPasswordChanged(_ cameraDevice: Device) {
//        let showPopupPasswordChanged = {
//            UIViewController.topViewController?.navigationController?.popToRootViewController(animated: true)
//            CameraManager.shared.showPopupCameraPasswordChanged(cameraDevice.name ?? "Camera")
//        }
//        
//        OHMeshService.deviceDetail(id: cameraDevice.id ?? 0)
//        .onSuccess { device in
//            if !(device.passwordView == nil || device.passwordView == cameraDevice.passwordView) {
//                showPopupPasswordChanged()
//            }
//        }
//        .onError { _ in
//            showPopupPasswordChanged()
//        }
//    }
}

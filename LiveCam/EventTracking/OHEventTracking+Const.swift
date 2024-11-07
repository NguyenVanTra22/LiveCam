//
//  OHEventTracking+Const.swift
//  OneHome
//
//  Created by ThiemJason on 11/13/23.
//  Copyright © 2023 VNPT Technology. All rights reserved.
//

import Foundation
import Alamofire

/// http://wiki.vnpt-technology.vn/display/SMARTHOME/ONE+Home+-+Firebase+Tracking+Events#ONEHome-FirebaseTrackingEvents-%C4%90%E1%BB%8Bnhngh%C4%A9aTrackingEventst%C3%ADchh%E1%BB%A3pFirebaseAnalytics
extension OHEventTracking {
    enum OHEvent {
        // MARK: - Auth
        case authLoginSubmitClicked                         /// Click Đăng nhập
        case authLoginSuccess(username: String)             /// Đăng nhập thành công
        case authLoginFail(username: String)                /// Đăng nhập thất bại
        case authRegisterClicked                            /// Click Đăng ký tài khoản
        case authRegisterSubmitClicked(username: String)    /// Click submit Đăng ký tài khoản
        case authForgotPassClicked                          /// Click Quên mật khẩu
        case authForgotPassSubmitClicked(username: String)  /// Click submit quên mật khẩu
        
        // MARK: - Home
        case homeView                                       /// Hiển thị Trang chủ
        case homeListReloaded(manual: Bool)                 /// Reload trang chủ, `manual: true | false` (Người dùng thao tác reload bằng tay)
        case homeTabHomeClicked                             /// Click nút Trang chủ
        case homeTabSmartClicked                            /// Click nút Kịch bản thông minh
        case homeTabNotiClicked                             /// Click nút Thông báo
        
        // MARK: - Device detail
        case deviceDetailView(deviceId: String, deviceModel: String)    /// Chi tiết thiết bị (Màn hình điều khiển chính): Tất cả thiết bị, Gateway, Camera, IR, ONT/Mesh, Switch, Plug, Sensor,.....
        case deviceIotControlClicked(deviceId: String, deviceModel: String, trait: String, value: String) /// Điều khiển 1 thiết bị IoT
        case deviceSettingClicked(deviceId: String, deviceModel: String) /// Click Cài đặt thiết bị
        case deviceSettingRenameSuccess(deviceId: String, deviceModel: String) /// Đổi tên thiết bị thành công từ màn cài đặt
        case deviceSettingDeleteSuccess(deviceId: String, deviceModel: String) /// Xoá thiết bị thành công từ màn cài đặ
        
        // MARK: - Firmware
        case firmwareUpdateClicked(deviceId: String, deviceModel: String, fwTargetVersion: String, fwCurrentVersion: String)
        case firmwareUpdateSuccess(deviceId: String, deviceModel: String, fwTargetVersion: String, fwCurrentVersion: String)
        case firmwareUpdateFailed(deviceId: String, deviceModel: String, fwTargetVersion: String, fwCurrentVersion: String)
        
        // MARK: - Camera
        case camPtzUpClicked(modelCode: String)
        case camPtzDownClicked(modelCode: String)
        case camPtzLeftClicked(modelCode: String)
        case camPtzRightClicked(modelCode: String)
        case camPtzPresetClicked(modelCode: String)         // Click PTZ vị trí mặc định
        case camLivePlaybackClicked(modelCode: String)
        case camLiveP2tClicked(modelCode: String)
        case camLiveSleepClicked(modelCode: String)
        case camLiveMuteClicked(modelCode: String)
        case camLiveScreenShotClicked(modelCode: String)
        case camLiveRecordClicked(modelCode: String)
        case camLiveResolutionClicked(modelCode: String)
        case camLiveFullscreenClicked(modelCode: String)
        case camLiveReloadClicked(modelCode: String)        /// Click kết nối lại camera
        case camLiveNotifyClicked(modelCode: String)        /// Click xem thông báo trong liveview
        case camLiveFlipClicked(modelCode: String)
        case camLiveSettingClicked(modelCode: String)
        case camSettingOffClicked(modelCode: String)
        case camSettingWdrClicked(modelCode: String)
        case camSettingWaterMarkClicked(modelCode: String)
        case camSettingMDNotifyClicked(modelCode: String)
        case camLiveConnectfailed(uid: String, modelCode: String, errorCode: String)
        case camGalleryClicked
        case camGalleryViewModel(viewModel: String, total: String) /// `viewModel` : Chế độ xem 1|4|9,  `total`: Tổng số lượng camera trong gallery
        
        // MARK: Automation
        case automationListView
        case automationListReloaded(manual: Bool)
        case automationToggleClicked(enable: Bool, id: String)
        case automationDetailView(id: String)
        
        // MARK: Scene
        case sceneListView
        case sceneListReloaded(manual: Bool)
        case sceneActiveClicked(id: String)
        case sceneDetailView(id: String)
        
        // MARK: Add device
        case categoriesView                                 /// Hiển thị Danh mục thiết bị để thêm
        case categoriesClicked(name: String)                /// Click vào 1 nhóm thiết bị, `name`: Tên danh mục (Nhóm thiết bị)
        case categoriesSearchSuccess(keyword: String)       /// Tìm kiếm 1 từ khoá trong màn Thêm thiết b, `keyword`: Từ khoá tìm kiếm
        case categoriesDeviceClicked(modelCode: String)     ///  Click vào 1 thiết bị cụ thể để bắt đầu thêm, `model_code`: Mã Dòng thiết bị
        case addDeviceFaqClicked(typeCode: String, modelCode: String) /// Click FAQ tại màn Hướng dẫn reset thiết bị
        case addDeviceSuccess(modelCode: String)            /// Thêm thiết bị thành công (Trước khi sang màn đặt tên)
        case addDeviceFail(modelCode: String, errorKey: String) /// `error_key`: "timeout" | Backend errorKey (Nếu hết thời gian timeout thì gửi lên "timeout")
        case addDeviceCancelClicked(modelCode: String)      /// Click nút Back/Huỷ ở màn Chờ kết nối
        case addDeviceRoomClicked(modelCode: String)        ///  Click Chọn phòng ở màn đặt tên thiết bị (Không áp dụng các thiết bị có bước Chọn phòng riêng)
        case addCameraModeClicked(mode: String)             /// Click mode pair Camera, `mode`: "AP" | "QR"
        
        // MARK: Menu
        case menuView
        case accountView
        case homeListView
        case memberListView
        case memberAddClicked
        case memberSaveClicked
        case settingView
        case cloudListView
        case playbackCloudListView
        case playbackCloudDetailView(uid: String, modelCode: String) /// Hiển thị chi tiết 1 Playback
        case helpView
        case menuLogoutClicked
        
        // MARK: iGate
        case wifiConnectType(modelCode: String, connectType: String)
        case wifiSpeedTestClicked(modelCode: String, model: String)
        case wifiListDeviceClicked(modelCode: String, model: String)
        case wifiListClientClicked(modelCode: String, model: String)
        case wifiAddDevice(modelCode: String, model: String)
        case wifiListSsidClicked(modelCode: String, model: String)
    }
}

extension OHEventTracking.OHEvent {
    // MARK: - Event name
    var name: String {
        switch self {
                // MARK: - Auth
            case .authLoginSubmitClicked:
                return "auth_login_submit_clicked"
            case .authLoginSuccess(username: _):
                return "auth_login_success"
            case .authLoginFail(username: _):
                return "auth_login_failed"
            case .authRegisterClicked:
                return "auth_register_clicked"
            case .authRegisterSubmitClicked(username: _):
                return "auth_register_submit_clicked"
            case .authForgotPassClicked:
                return "auth_forgot_pass_clicked"
            case .authForgotPassSubmitClicked(username: _):
                return "auth_forgot_pass_submit_clicked"
                
                // MARK: - Home
            case .homeView:
                return "home_view"
            case .homeListReloaded(manual: _):
                return "home_list_reloaded"
            case .homeTabHomeClicked:
                return "tab_home_clicked"
            case .homeTabSmartClicked:
                return "tab_smart_clicked"
            case .homeTabNotiClicked:
                return "tab_noti_clicked"
                
                // MARK: - Device detail
            case .deviceDetailView(deviceId: _, deviceModel: _):
                return "device_detail_view"
            case .deviceIotControlClicked(deviceId: _, deviceModel: _, trait: _, value: _):
                return "device_iot_control_clicked"
            case .deviceSettingClicked(deviceId: _, deviceModel: _):
                return "device_setting_clicked"
            case .deviceSettingRenameSuccess(deviceId: _, deviceModel: _):
                return "device_setting_rename_success"
            case .deviceSettingDeleteSuccess(deviceId: _, deviceModel: _):
                return "device_setting_delete_success"
                
                // MARK: - Firmware
            case .firmwareUpdateClicked(deviceId: _, deviceModel: _, fwTargetVersion: _, fwCurrentVersion: _):
                return "fw_update_clicked"
            case .firmwareUpdateSuccess(deviceId: _, deviceModel: _, fwTargetVersion: _, fwCurrentVersion: _):
                return "fw_update_success"
            case .firmwareUpdateFailed(deviceId: _, deviceModel: _, fwTargetVersion: _, fwCurrentVersion: _):
                return "fw_update_failed"
                
                // MARK: - Camera
            case .camPtzUpClicked(modelCode: _):
                return "camera_ptz_up_clicked"
            case .camPtzDownClicked(modelCode: _):
                return "camera_ptz_down_clicked"
            case .camPtzLeftClicked(modelCode: _):
                return "camera_ptz_left_clicked"
            case .camPtzRightClicked(modelCode: _):
                return "camera_ptz_right_clicked"
            case .camPtzPresetClicked(modelCode: _):
                return "camera_ptz_reset_clicked"
            case .camLivePlaybackClicked(modelCode: _):
                return "camera_live_playback_clicked"
            case .camLiveP2tClicked(modelCode: _):
                return "camera_live_p2t_clicked"
            case .camLiveSleepClicked(modelCode: _):
                return "camera_live_sleep_clicked"
            case .camLiveMuteClicked(modelCode: _):
                return "camera_live_mute_clicked"
            case .camLiveScreenShotClicked(modelCode: _):
                return "camera_live_screenshot_clicked"
            case .camLiveRecordClicked(modelCode: _):
                return "camera_live_record_clicked"
            case .camLiveResolutionClicked(modelCode: _):
                return "camera_live_resolution_clicked"
            case .camLiveFullscreenClicked(modelCode: _):
                return "camera_live_fullscreen_clicked"
            case .camLiveReloadClicked(modelCode: _):
                return "camera_live_reload_clicked"
            case .camLiveConnectfailed(uid: _, modelCode: _, errorCode: _):
                return "camera_live_connect_failed"
            case .camLiveNotifyClicked(modelCode: _):
                return "camera_live_notify_clicked"
            case .camLiveFlipClicked(modelCode: _):
                return "camera_live_flip_clicked"
            case .camLiveSettingClicked(modelCode: _):
                return "camera_live_setting_clicked"
            case .camSettingOffClicked(modelCode: _):
                return "camera_setting_off_clicked"
            case .camSettingWdrClicked(modelCode: _):
                return "camera_setting_wdr_clicked"
            case .camSettingWaterMarkClicked(modelCode: _):
                return "camera_setting_watermark_clicked"
            case .camSettingMDNotifyClicked(modelCode: _):
                return "camera_setting_md_notify_clicked"
            case .camGalleryClicked:
                return "camera_gallery_clicked"
            case .camGalleryViewModel(viewModel: _, total: _):
                return "camera_gallery_viewmode"
                
                // MARK: - Automation
            case .automationListView:
                return "automation_list_view"
            case .automationListReloaded(manual: _):
                return "automation_list_reloaded"
            case .automationToggleClicked(enable: _, id: _):
                return "automation_toggle_clicked"
            case .automationDetailView(id: _):
                return "automation_detail_view"
                
                // MARK: - Scene
            case .sceneListView:
                return "scene_list_view"
            case .sceneListReloaded(manual: _):
                return "scene_list_reloaded"
            case .sceneActiveClicked(id: _):
                return "scene_activate_clicked"
            case .sceneDetailView(id: _):
                return "scene_detail_view"
                
                // MARK: - Add Device
            case .categoriesView:
                return "categories_view"
            case .categoriesClicked(name: _):
                return "category_clicked"
            case .categoriesSearchSuccess(keyword: _):
                return "category_search_success"
            case .categoriesDeviceClicked(modelCode: _):
                return "category_device_clicked"
            case .addDeviceFaqClicked(typeCode: _, modelCode: _):
                return "add_device_faq_clicked"
            case .addDeviceSuccess(modelCode: _):
                return "add_device_success"
            case .addDeviceFail(modelCode: _, errorKey: _):
                return "add_device_failed"
            case .addDeviceCancelClicked(modelCode: _):
                return "add_device_cancel_clicked"
            case .addDeviceRoomClicked(modelCode: _):
                return "add_device_room_clicked"
            case .addCameraModeClicked(mode: _):
                return "add_camera_mode_clicked"
                
                // MARK: - Menu
            case .menuView:
                return "menu_view"
            case .accountView:
                return "account_view"
            case .homeListView:
                return "home_list_view"
            case .memberListView:
                return "member_list_view"
            case .memberAddClicked:
                return "member_add_clicked"
            case .memberSaveClicked:
                return "member_save_clicked"
            case .settingView:
                return "settings_view"
            case .cloudListView:
                return "cloud_list_view"
            case .playbackCloudListView:
                return "playback_cloud_list_view"
            case .playbackCloudDetailView(uid: _, modelCode: _):
                return "playback_cloud_detail_view"
            case .helpView:
                return "help_view"
            case .menuLogoutClicked:
                return "menu_logout_clicked"
            case .wifiConnectType(modelCode: _, connectType: _):
                return "wifi_connect_type"
            case .wifiSpeedTestClicked(modelCode: _, model: _):
                return "wifi_speed_test_clicked"
            case .wifiListDeviceClicked(modelCode: _, model: _):
                return "wifi_list_device_clicked"
            case .wifiListClientClicked(modelCode: _, model: _):
                return "wifi_list_client_clicked"
            case .wifiAddDevice(modelCode: _, model: _):
                return "wifi_add_device"
            case .wifiListSsidClicked(modelCode: _, model: _):
                return "wifi_list_ssid_clicked"
        }
    }
}

extension OHEventTracking.OHEvent {
    // MARK: - Event name
    var params: Parameters? {
        switch self {
                // MARK: - Auth
            case .authLoginSuccess(username: let username),
                    .authLoginFail(username: let username),
                    .authRegisterSubmitClicked(username: let username),
                    .authForgotPassSubmitClicked(username: let username):
                return ["username": username]
                
                // MARK: - Home
            case .homeListReloaded(manual: let manual):
                return ["manual": manual]
                
                // MARK: - DeviceDetail
            case .deviceDetailView(deviceId: let deviceId, deviceModel: let deviceModel),
                    .deviceSettingClicked(deviceId: let deviceId, deviceModel: let deviceModel),
                    .deviceSettingRenameSuccess(deviceId: let deviceId, deviceModel: let deviceModel),
                    .deviceSettingDeleteSuccess(deviceId: let deviceId, deviceModel: let deviceModel):
                return ["device_id": deviceId, "device_model": deviceModel]
            case .deviceIotControlClicked(deviceId: let deviceId, deviceModel: let deviceModel, trait: let trait, value: let value):
                return [
                    "device_id": deviceId,
                    "device_model": deviceModel,
                    "trait": trait,
                    "trait_value": value
                ]
                
                // MARK: - Firmware
            case .firmwareUpdateClicked(deviceId: let deviceId, deviceModel: let deviceModel, fwTargetVersion: let fwTargetVersion, fwCurrentVersion: let fwCurrentVersion),
                    .firmwareUpdateSuccess(deviceId: let deviceId, deviceModel: let deviceModel, fwTargetVersion: let fwTargetVersion, fwCurrentVersion: let fwCurrentVersion),
                    .firmwareUpdateFailed(deviceId: let deviceId, deviceModel: let deviceModel, fwTargetVersion: let fwTargetVersion, fwCurrentVersion: let fwCurrentVersion):
                return [
                    "device_id": deviceId,
                    "device_model": deviceModel,
                    "fw_target_version": fwTargetVersion,
                    "fw_current_version": fwCurrentVersion
                ]
                
                // MARK: - Camera
            case .camPtzUpClicked(modelCode: let modelCode),
                    .camPtzDownClicked(modelCode: let modelCode),
                    .camPtzLeftClicked(modelCode: let modelCode),
                    .camPtzRightClicked(modelCode: let modelCode),
                    .camPtzPresetClicked(modelCode: let modelCode),
                    .camLivePlaybackClicked(modelCode: let modelCode),
                    .camLiveP2tClicked(modelCode: let modelCode),
                    .camLiveSleepClicked(modelCode: let modelCode),
                    .camLiveMuteClicked(modelCode: let modelCode),
                    .camLiveScreenShotClicked(modelCode: let modelCode),
                    .camLiveRecordClicked(modelCode: let modelCode),
                    .camLiveResolutionClicked(modelCode: let modelCode),
                    .camLiveFullscreenClicked(modelCode: let modelCode),
                    .camLiveReloadClicked(modelCode: let modelCode),
                    .camLiveNotifyClicked(modelCode: let modelCode),
                    .camLiveFlipClicked(modelCode: let modelCode),
                    .camLiveSettingClicked(modelCode: let modelCode),
                    .camSettingOffClicked(modelCode: let modelCode),
                    .camSettingWdrClicked(modelCode: let modelCode),
                    .camSettingWaterMarkClicked(modelCode: let modelCode),
                    .camSettingMDNotifyClicked(modelCode: let modelCode):
                return ["model_code": modelCode]
            case .camLiveConnectfailed(uid: let uid, modelCode: let modelCode, errorCode: let errorCode):
                return ["uid": uid, "model_code": modelCode, "error_message": errorCode]
                
            case .camGalleryViewModel(viewModel: let viewModel, total: let total):
                return ["view_mode": viewModel, "total": total]
                
                // MARK: - Automation
            case .automationListReloaded(manual: let manual):
                return ["manual": manual]
            case .automationToggleClicked(enable: let enable, id: let id):
                return ["enabled": enable, "id": id]
            case .automationDetailView(id: let id):
                return ["id": id]
                
                // MARK: - Scene
            case .sceneListReloaded(manual: let manual):
                return ["manual": manual]
            case .sceneActiveClicked(id: let id):
                return ["id": id]
            case .sceneDetailView(id: let id):
                return ["id": id]
                
                // MARK: Add Device
            case .categoriesClicked(name: let name):
                return ["name": name]
            case .categoriesSearchSuccess(keyword: let keyword):
                return ["keyword": keyword]
            case .categoriesDeviceClicked(modelCode: let modelCode):
                return ["model_code": modelCode]
            case .addDeviceFaqClicked(typeCode: let typeCode, modelCode: let modelCode):
                return ["type_code": typeCode, "model_code": modelCode]
            case .addDeviceSuccess(modelCode: let modelCode):
                return ["model_code": modelCode]
            case .addDeviceFail(modelCode: let modelCode, errorKey: let errorKey):
                return ["model_code": modelCode, "error_key": errorKey]
            case .addDeviceCancelClicked(modelCode: let modelCode):
                return ["model_code": modelCode]
            case .addDeviceRoomClicked(modelCode: let modelCode):
                return ["model_code": modelCode]
            case .addCameraModeClicked(mode: let mode):
                return ["mode": mode]
                
                // MARK: Menu
            case .playbackCloudDetailView(uid: let uid, modelCode: let modelCode):
                return ["uid": uid, "model_code": modelCode]
                
                // MARK: iGate Wifi
            case .wifiConnectType(modelCode: let modelCode, connectType: let connectType):
                return ["model_code": modelCode, "connect_type": connectType]
            case .wifiSpeedTestClicked(modelCode: let modelCode, model: let model),
                    .wifiListDeviceClicked(modelCode: let modelCode, model: let model),
                    .wifiListClientClicked(modelCode: let modelCode, model: let model),
                    .wifiAddDevice(modelCode: let modelCode, model: let model),
                    .wifiListSsidClicked(modelCode: let modelCode, model: let model):
                return ["model_code": modelCode, "model": model]
                
            default:
                return [:]
        }
    }
}

//
//  Constant.swift
//  OneHome
//
//  Created by Macbook Pro 2017 on 7/3/20.
//  Copyright © 2020 VNPT Technology. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire

var isPad = Bool()
var bagdeCount = 0 {
    didSet {
        // Cập nhật lại số thông báo ở icon app ngoài màn hình ứng dụng
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            if error != nil { return }
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = bagdeCount
            }
        }
    }
}
var wifiName = String()
var connectionFlagFastMode:Int32 = 1
var connectionFlagDefault:Int32 = 0
var isNeedUpdateFCMToken = false
var isAppInReview = false
var delayShowPopupSessionExpired = 1
var app_key = ""
var debugMode = false

struct Constant {
    static var isCurrentAccountDeletion : Bool? = nil
    static let dateBuild: String = "staging 24/08 14:11"
    struct RealmConfig {
        static let currentVersion:UInt64 = 13    // Add second in CreateRuleRequest
    }
    struct CameraType {
        static let KBR_INIT: String = "EBGJFNBBKLJIGEJLEGGLFJEFHFMDHNNEGCFEBLCIBJJBLNLHCNAHCFOFGDLCJELIAMMKLBDFOGMAAACMJKNBIBAL:KHJBR001"//brazil
        static let AISA_INIT: String = "EBGCFGBKKHJNGBJJEFHPFBENHLNBHAMGHOEIANDIBOINKHLBCCBDCHOCHOKLJLKIBNNILECMPPNHAP:KHJAISA001" //AISA
        static let EUR_INIT: String = "EDGGFCBNKNJHGLJEEEGFFHEIHNMMHCNLGGFABJCAAGJBLJLHDLAOCDOPGJLKIKLJANMNKBDKOPMGBMCOIG:KEUROPE001" //europe
        static let USA_INIT: String = "EBGEFABMKGJOGCJNEMGLFJEFHCMDHNNGHGFMBBDOAHJDLKKODNALCAPIGHLFIFLPBHNCKFDLPHNKBGDI:KUSAKEY001" //USA
        static let CN_INIT: String = "EBGEEHBHKOJHHNJNEMGNFPEJHNNHHENNGKFMBCDNAHJBLLKPDMAMCCPKGBLCJFLJAOMPLEDAODMEAGCKJMNGIHAN:KHJTEC001" //china
        static let VNT_INIT: String = "EBGFFBBNKGJEGIJFEBHLFFEJHFNPHMNAHAFKBECNALJOLAKEDEACCPPHGMLIIILIANMBKNDEOGNGBACAJCMG:VNPTKEY"
        static let VNTT_INIT: String = "EBGFFBBNKGJEGIJCEDHJFEEMHKNADCJIGGBNBDCAAGNGKGOMDKBDHNOMCFKNNNLAFKMBOEDHPLJDAJCHNDJJIPEKMHPGAMHOBKGICGAHIJOABFGNBJAIOMIJDMILEBCDFBFD:vnptT@12" // Chính thức cho camera mới
        static let PPCS_INIT: String = "EBGAEIBIKHJJGFJKEOGCFAEPHPMAHONDGJFPBKCPAJJMLFKBDBAGCJPBGOLKIKLKAJMJKFDOOFMOBECEJIM" // Thử nghiệm PPCS
    }
    
    struct Router {
//        static let domain = "http://203.162.94.39:9090/"domainServerTest
        static let domainServerTest = "http://203.162.94.39:9093/"
        //https://apionehome.vnpt-technology.vn/
        //https://710559cd3068.ngrok.io/
        //https://application-cloud.vnpt-technology.vn/
        //https://stagingapionehome.vnpt-technology.vn
        //devapionehome.vnpt-technology.vn
//        203.162.94.39:9093
        //        stagingapionehome.vnpt-technology.vn

//        static let domain = OHConfigurationManager.baseURL
//        static let mqttDomainConstant = OHConfigurationManager.mqttHost
//        static let mqttPort = OHConfigurationManager.mqttPort
        static let mqttSSLEnabled = true

//        static let apiPrefix = "\(domain)/api/"
        
//        static let domain_ = "http://14.238.30.231:9093"
//        static let domain2 = "http://14.238.30.231:9093/api/"
        
        static let stagingDomain = "https://stagingapionehome.vnpt-technology.vn/api/"
        
        //user guide
//        static let userGuidePrefix = "\(domain):2001/docs/onehome/user-guides/"
        static let linkFAQ = "https://sanphamvnpt.vn/question"
        
        // user
        static let Login = "auth/token"
        static let Register = "users/register"
        static let ForgotPassword = "users/forgot-password/init"
        static let OTPAuthen = "users/otp-authentication"
        static let ResetPassword = "users/reset-password"
        static let ChangePassword = "users/change-password"
        static let ResendOTP = "users/resend-otp-code"
        static let UserCurrent = "users/current"
        static let DeleteUser = "users/delete-user"
        static let UpdateUser = "users/"
        static let Logout = "users/logout"
        
        // config
        static let inReview = "configs/activate?id=10"
        
        //home
        static let getCurrentHome = "homes/current?homeId="
        static let ChangeCurrentHome = "users/change-current-home"
        static let SearchHome = "homes/search?query=&page=0&size=&sort=id,desc"
        static let Home = "homes"
        static let HomeInfo = "users/current"
        static let searchHomeCommon = "homes/search"
        
        //Room
        static let rooms = "rooms/"
        static let searchRoomByHomeID = "rooms"
        
        //Upload file
        static let uploadFile = "files/upload"
        static let deleteFile = "files/delete-file-uploaded?fileName="
        static let uploadSnapshot = "files/upload-snapshot"
        // Device
        static let getDeviceByRoomAndHome = "devices"
        static let getListDeviceByHomeAndUser = "devices/search"
        static let createDevice = "devices"
        static let moveDevices = "devices/move"
        static let devices = "devices/"
        static let addDevicesGallery = "devices/add-device-gallery-view"
        static let removeDevicesGallery = "devices/remove-device-gallery-view"
        static let deleteDevices = "devices/"
        static let batchDeleteDevices = "devices/batch-delete"
        static let updateDeviceStatus = "devices/change-status/"
        static let getListDeviceNotRegistered = "devices/search-api?query=servicePaymentId==null;ownId==&size=100&sort=created,desc"
        static let updateDeviceFirmware = "devices/update-firmware-version"
        static let changeDeviceStatusFirmware = "devices/change-status-update-firmware"
        static let controlDevice = "devices/control-device"
        static let currentData = "devices/current-data"
        static let allCurrentData = "devices/all-current-data"
        
        //QR
        static let scanNewCamera = "devices/scan-new-camera"
        //Policy
        static let getPolicyForDevice = "policy/get-policy-for-device"
        static let checkDevicePolicy = "policy/check-policy-is-execute"
        //SOS
        static let createSos = "users/sos-create"
        static let getListSos = "users/sos-search?query="
        static let deletaSos = "users/sos-delete/"
        static let updateSos = "users/sos-update/"
        //Noti
        static let getNoti = "notifications/"
        static let addTokenUser = "users/token-notification"
        static let updateIsRead = "notifications/update-is-read"
        static let updateIsNew = "notifications"
        static let getDetailNoti = "notifications"
        //Timezone
        static let getTimeZone = "timezone/get-time-zone-list"
        static let gatewayUpdateTimezone = "devices/gateway-update-timezone"
        static let getTimeZoneID = "timezone"
        //Subcription - Payment
        static let searchServicePayment = "service-payments"
        static let getServicePayment = "service-payments/"
        static let addDevicePayment = "service-payments/add-devices"
        static let searchServicePaymetUnregister = "service-packages"
        static let searchServicePaymetUnregisterForBundle = "service-packages/get-unregistered-service-package"
        static let registerServicePayment = "service-payments/register"
        static let unregisterServicePayment = "service-payments/deactivate?id="
        static let removeDevicePayment = "service-payments/remove-devices"
        
        //Cloud
        static let cloudListFile = "cloud/getMetadata"
        static let cloudPlayBack = "cloud/cloudPlayRecorded"
        static let cloudDownloadVideo = "cloud/cloudDownloadRecorded"
        static let cloudGGDownloadVideo = "cloud/ggCloudDownloadRecorded"
        static let cloudDeleteVideo = "cloud/delete"
        static let cloudTimeDownload = "cloud/cloudTimeDownload"
        static let getListDevice = "devices"
        
        //2.0
        static let getGatewayStatus = "devices/gateway-status"
        static let openZigbeeNetwork = "devices/open-zigbee-network-gateway"
        static let getGatewayVirtualDevice = "virtual-devices/virtual-device/GW"
        static let getAllGateway = "devices"
        static let searchGraphs = "graphs/search-graphs"
        static let smartPlugAverageValue = "graphs/smart-plug-average-value"
        static let historySensor = "telemetry-logs"
        static let createContext = "rules"
        static let getListContext = "rules"
        static let activateContext = "rules/control-rule"
        static let delteteContext = "rules/batch-delete"
        static let getDetailContext = "rules"
        static let deleteContext = "rules"
        static let updateContext = "rules"
//        static let getListNewDevice = "device-types/search?query=code!='GR'"
        static let getListNewDevice = "device-types/search?query=name=='**'&page=0&size=100&sort=itemIndex"
        static let getListCameraDevice = "device-types/search?query=code!='GR';id==1"

        static let getListNewChildDevice = "device-models"
        static let checkAddGateway = "devices"


        //rule
        static let rule = "rules"
        static let toggleRule = "rules/toggle-rule"
        
        //sunset
        static let timeSun = ""
        
        //2.1
        static let gatewayBuzzerState = "devices/gateway-buzzer-state"
        static let gatewayData = "devices/gateway-data"
        static let gatewayBuzzerControl = "devices/gateway-buzzer-control"
        static let gatewayNotification = "devices/gateway-notification"
        static let gatewayBuzzerVolume = "devices/gateway-buzzer-volume"
        
        static let deleteNotification = "notifications/batch-delete"
        
        //sharing
        static let createMember = "members"
        static let getDetailMember = "members"
        static let getListMember = "members"
        static let leaveHome = "members"
        static let deactivateMember = "members/deactivate"
        static let updateMember = "members"
        static let updateMemberNickname = "user-member"
        static let inviteMember = "members/invite-member"
        static let cancelInviteMember = "members/cancel-invite"
        static let acceptInviteMember = "members"
        
        //feedback
        static let sendFeedback = "comments"
        
        //2.3
        static let listBulbScenes = "scenes"
        static let configBulb = "devices/config-light"
        static let openBluetoothGateway = "devices/open-bluetooth-gateway"
        static let getListGroupLight = "group-devices"
        static let addToGroup = "devices/add-to-group"
        static let createGroup = "group-devices"
        static let moveToGroup = "devices/move-to-group/"
        static let deleteFromGroup = "devices/delete-from-group/"
        
        //2.3.3
        static let forceUpdateVersion = "mobile-version-manager"
        
        //3.0.3
        static let updateFWFAQ  = "faq/support-update"
        
        // 3.1.1
        static let serviceDevicesPlayback   = "service-devices/get-device-in-playback"
        static let changeStatusTokenFCM     = "notifications/change-status-token-firebase"
        
        // 3.2.5
        static let registerTuyaAccount = "users/tuya-register"
    }
    
    struct Params {
        static let Id = "id"
        static let UserName = "username"
        static let Password = "password"
        static let RememberMe = "rememberMe"
        static let type = "type"
        static let LangKey = "langKey"
    }
    
    struct Font {
        static let Roboto_Regular = "Roboto-Regular"
        static let Roboto_Medium = "Roboto-Medium"
        static let Roboto_Bold = "Roboto-Bold"
        
        static let OpenSans_Regular = "OpenSans-Regular"
        static let OpenSans_Medium = "OpenSans-Medium"
        static let OpenSans_Bold = "OpenSans-Bold"
        static let OpenSans_SemiBold = "OpenSans-SemiBold"

    }
    
    struct Color {
        static let white_gray = UIColor(red: 173/255, green: 194/255, blue: 208/255, alpha: 1)
        static let dark_blue_bg = UIColor(red: 48/255, green: 110/255, blue: 197/255, alpha: 0.2)
        static let dark_blue_border_btn = UIColor(red: 45/255, green: 116/255, blue: 231/255, alpha: 1)
        static let black_opa_60 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        static let light_opa_50 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        static let light_opa_70 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        static let format_red = UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 1)
        static let gray = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.8)
        static let lightGray_opa_25 = UIColor(red: 185/255, green: 211/255, blue: 210/255, alpha: 0.3)
        static let lightGray_opa_65 = UIColor(red: 185/255, green: 211/255, blue: 210/255, alpha: 0.65)
        static let lightGray_opa = UIColor(red: 98/255, green: 151/255, blue: 185/255, alpha: 1)
        static let gray_light = UIColor(red: 218/255, green: 234/255, blue: 245/255, alpha: 1)
        static let gray_dark = UIColor(red: 138/255, green: 145/255, blue: 150/255, alpha: 1)

        static let gray_light_opa_50 = UIColor(red: 218/255, green: 234/255, blue: 245/255, alpha: 0.5)
        static let orange_opa_80 = UIColor(red: 242/255, green: 153/255, blue: 74/255, alpha: 0.8)
        static let orange_opa_50 = UIColor(red: 242/255, green: 153/255, blue: 74/255, alpha: 0.5)
        static let orange = UIColor(red: 242/255, green: 153/255, blue: 74/255, alpha: 1)
        static let black_opa_50 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        static let black_opa_25 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        static let blue_dim = UIColor(red: 113/255, green: 162/255, blue: 191/255, alpha: 1)
        static let eastern_blue = UIColor(red: 0/255, green: 119/255, blue: 149/255, alpha: 1)
        static let regel_blue = UIColor(red: 28/255, green: 56/255, blue: 80/255, alpha: 1)
        static let lightGray_blue = UIColor(red: 173/255, green: 194/255, blue: 208/255, alpha: 1)
        static let gray_white = UIColor(red: 231/255, green: 236/255, blue: 237/255, alpha: 1)
        static let gray_9EB6C3 = UIColor(red: 158/255, green: 182/255, blue: 195/255, alpha: 1)
        static let yellow_FFD54F = UIColor(red: 255/255, green: 213/255, blue: 79/255, alpha: 1)
        
        // One meme 2.0
        static let app_background = UIColor(red: 241/255, green: 245/255, blue: 252/255, alpha: 1)
        static let dark_blue = UIColor(red: 22/255, green: 50/255, blue: 85/255, alpha: 1)
        static let btn_on_color = UIColor(red: 161/255, green: 190/255, blue: 228/255, alpha: 1)
        static let btn_off_color = UIColor(red: 211/255, green: 222/255, blue: 228/255, alpha: 1)
        
        static let tabar_selected = UIColor(red: 45/255, green: 116/255, blue: 231/255, alpha: 1)
//        static let tabar_unselected = UIColor.neutral70 //UIColor(red: 158/255, green: 182/255, blue: 195/255, alpha: 0.5)
        static let border_Textfield = UIColor(red: 158/255, green: 182/255, blue: 195/255, alpha: 1)

        
        static let gray_background = UIColor(red: 241/255, green: 245/255, blue: 252/255, alpha: 1)
        static let orange_background = UIColor(red: 242/255, green: 153/255, blue: 74/255, alpha: 0.1)
        static let blue_text_device = UIColor(red: 21/255, green:50/255, blue: 80/255, alpha: 1)
        static let gray_text_opa = UIColor(red: 158/255, green:181/255, blue:195/255, alpha: 1)
        static let blue_view_and_status = UIColor(red: 44/255, green: 116/255, blue: 231/255, alpha: 1)
        static let orange_text_smoke = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let gray_background_left_menu = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        static let gray_background_search_bar = UIColor(red: 21/255, green: 49/255, blue: 85/255, alpha: 0.1)
        static let gray_text_placeholder_search_bar = UIColor(red: 21/255, green:49/255, blue: 85/255, alpha: 0.5)
        static let blue_shadow = UIColor(red: 76/255, green: 169/255, blue: 223/255, alpha: 1)
        static let blue_corner = UIColor(red: 76/255, green: 169/255, blue: 223/255, alpha: 0.1)
        static let hex_C4D9FD = UIColor(red: 196/255, green: 217/255, blue: 252/255, alpha: 1)
        
        static let start_gradient = UIColor(red: 76/255, green: 169/255, blue: 223/255, alpha: 1)
        static let end_gradient = UIColor(red: 45/255, green: 116/255, blue: 231/255, alpha: 1)
        static let gray_boder = UIColor(red: 158/255, green: 182/255, blue: 196/255, alpha: 1)
        
        static let hex_FF4C4C = UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 1)
        static let hex_FF4C4C_op50 = UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 0.5)
//        static let hex_C4D9FD = UIColor(red: 196/255, green: 217/255, blue: 252/255, alpha: 1)
        static let hex_F1F5FC = UIColor(red: 241/255, green: 245/255, blue: 252/255, alpha: 1)
        static let hex_2D74E7 = UIColor(red: 45/255, green: 116/255, blue: 231/255, alpha: 1)
        static let hex_2D74E7_op50 = UIColor(red: 45/255, green: 116/255, blue: 231/255, alpha: 0.5)
        static let hex_748792 = UIColor(red: 116/255, green: 135/255, blue: 146/255, alpha: 1)
        static let hex_9EB6C3_op50 = UIColor(red: 158/255, green: 182/255, blue: 196/255, alpha: 0.5)
        static let hex_9EB6C3_op20 = UIColor(red: 158/255, green: 182/255, blue: 196/255, alpha: 0.2)
        static let hex_9EB6C3 = UIColor(red: 158/255, green: 182/255, blue: 196/255, alpha: 1)
        static let hex_E5E5E5 = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        static let hex_ADC2D0 = UIColor(red: 173/255, green: 194/255, blue: 208/255, alpha: 1)
        static let hex_ADC2D0_op60 = UIColor(red: 173/255, green: 194/255, blue: 208/255, alpha: 0.6)
        static let dark_orange = UIColor(red: 255/255, green: 128/255, blue: 11/255, alpha: 1)
        static let dark_red = UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 1)
        static let invisible = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        static let hex_E0E8F1 = UIColor(red: 224/255, green: 232/255, blue: 241/255, alpha: 1)

        static let deep_dark_blue = UIColor(red: 14/255, green: 72/255, blue: 167/255, alpha: 1)
        
        static let hex_1CDD46 = UIColor(red: 28/255, green: 221/255, blue: 70/255, alpha: 1)
        
        static let hex_163255 = UIColor(red: 22/255, green: 50/255, blue: 85/255, alpha: 1)
        
        static let hex_8CC153 = UIColor(red: 140/255, green: 193/255, blue: 83/255, alpha: 1)
        
        static let hex_EBEFF3 = UIColor(red: 235/255, green: 239/255, blue: 243/255, alpha: 1)
        static let hex_9EB6C4 = UIColor(red: 158/255, green: 182/255, blue: 196/255, alpha: 1)
        static let hex_F2994A = UIColor(red: 242/255, green: 153/255, blue: 74/255, alpha: 1)
        static let hex_CADAF1 = UIColor(red: 202/255, green: 218/255, blue: 241/255, alpha: 1)
        
        static let hex_4CA9DF = UIColor(red: 76/255, green: 169/255, blue: 223/255, alpha: 1)
        
        static let hex_E99749 = UIColor(red: 233/255, green: 151/255, blue: 73/255, alpha: 1)
        
        static let hex_E95B5B = UIColor(red: 233/255, green: 91/255, blue: 91/255, alpha: 1)
        static let hex_DF4F17 = UIColor(red: 233/255, green: 79/255, blue: 23/255, alpha: 1)
        
        static let hex_7EADE0 = UIColor(red: 126/255, green: 173/255, blue: 224/255, alpha: 1)
        static let hex_94A7C2 = UIColor(red: 148/255, green: 167/255, blue: 194/255, alpha: 1)
        static let hex_red_FCE0E0   = UIColor(red: 252/255, green: 224/255, blue: 224/255, alpha: 1)
        static let hex_red_EF4344   = UIColor(red: 239/255, green: 67/255, blue: 68/255, alpha: 1)
        static let hex_gray_EF4344  = UIColor(red: 225/255, green: 233/255, blue: 242/255, alpha: 1)
        static let hex_gray_BFCAD9  = UIColor(red: 191/255, green: 202/255, blue: 217/255, alpha: 1)
        static let hex_gray_8B9CB2  = UIColor(red: 139/255, green: 156/255, blue: 178/255, alpha: 1)
        
        /// Danh sách gói cước
        static let hex_green_19C285     = UIColor(red: 25/255, green: 194/255, blue: 133/255, alpha: 1)
        static let hex_red_F67280       = UIColor(red: 246/255, green: 114/255, blue: 128/255, alpha: 1)
        static let hex_orange_F3AB1D    = UIColor(red: 243/255, green: 171/255, blue: 29/255, alpha: 1)
        static let hex_gray_9EB6C3      = UIColor(red: 158/255, green: 182/255, blue: 195/255, alpha: 1)
        static let hex_30_163255        = UIColor(red: 22/255, green: 50/255, blue: 85/255, alpha: 0.3)
        static let hex_F2994A_op90      = UIColor(red: 242/255, green: 153/255, blue: 74/255, alpha: 0.1)
    }
    
    struct imageName {
        static let Background = "background"
        static let Logo = "home-login"
        static let MenuIcon = "MenuIcon"
        static let MoreIcon = "MoreIcon"
        static let GaleryIcon = "GaleryIcon"
        static let CameraOnlineIcon = "CameraOnlineIcon"
        static let CameraOfflineIcon = "CameraOfflineIcon"
        
        static let home = "icon-home"
        static let honeDefault = "icon-home-default"
        static let angelright = "icon-angel-right"
        static let EditIcon = "Group 248"
        
        static let HomeTabIcon = "HomeTabIcon"
        static let NotiTabIcon = "NotiTapIcon"
        
        static let AvatarPlaceHolder = "icon_avatar_place_holder"
        static let CameraPlaceHolder = "img_black"
        
        static let iconUncheckWhite = "icon-uncheck-white"
        static let iconCheckWhite = "icon-check-white"
        static let iconUncheckWhiteOpa50 = "icon-uncheck-white-opa50"
        static let notifyOff = "icon-notify-off"
        
        static let iconCamera = "Icon_camera"
        static let iconSensor = "ic_temp_sensor"
        static let iconSmokeSensor = "ic_smoke_sensor"
        static let iconDoorSensor = "ic_door_sensor"
        static let iconPirSensor = "ic_motion_sensor"
        static let iconGateway = "Icon_gateway"
        //static let iconSmartSwitch_no_number = "Icon_smart_switch_no_number"
        //static let iconSmartSwitch = "Icon_smart_switch"
        static let iconSmartSwitch_no_number = "ic_smart_switch"
        static let iconSmartSwitch = "ic_smart_switch"
        static let iconSmartPlug = "Icon_smart_plug"
    }
    
    struct Values {
        static let currentTimeZone = "Asia/Ho_Chi_Minh"
        static let scaledUIWidth: CGFloat = UIScreen.main.bounds.width / 1440
        static let scaledUIHeight: CGFloat = UIScreen.main.bounds.height / 2910
        static let sizeOnEachPage: Int = 5 // for query paging
        static let defaultAvatarRoom = "ic_default_room"
        static let placeHolderAvatarRoom = "placeholder"
        static let searchByHome = "homeId==%d"
//        static let urlImageWithPath = "\(Router.domain)"
        static let fontNameCommon = "Roboto-Regular"
        static let fontNameNavigation = "Roboto-Medium"
        static let sizeTextHeaderScreen: CGFloat = 17
        static let sizeTextNavigationScreen: CGFloat = 24
        static let sizeTextLabelCell: CGFloat = 17
        static let sizeTextSubline: CGFloat = 12
        static let searchDeviceByHome = "homeId==%d"
        static let searchDeviceByHomeAndUser = "homeId==%d;roomId==%d"
        static let searchHomeDetailById = "id==%d"
        static let widthIconNavigation: CGFloat = 17 // using for back button
        static let minTempcolor = 800 //Độ ấm trên thiết bị đèn:min 800K
        static let maxTempcolor = 20000 //Độ ấm trên thiết bị đèn:max 20000k
        static let defaultTempcolor: Int = Int((maxTempcolor - minTempcolor) / 2) + minTempcolor // 50 % trên slider
        static let neutralTempcolor = 5000 //Độ ấm trung tính trên đèn: 5000K
        static let neutralBrightness = 70 //Độ sáng trung tính trên đèn: 70 %
        static let pageSizeServicePlan = 20
        static let irPageSize = 20
        static let defaultPhonePageSize = 10
        static let defaultIpadPageSize = 15
    }
    
    struct UserDefault {
        static let IsNotFirstTimeCreateAccount = "IsNotFirstTimeCreateAccount"
        static let UserInfoCurrent = "UserInfoCurrent"
        static let UserId = "UserId"
    }
    
//    static func imageUrlWithPath(_ pathImage: String) -> String {
//        return "\(Constant.Router.apiPrefix)\(pathImage)"
//    }
    
    enum DeviceType: String {
        case camera176 = "176"
        case camera177 = "177"
        case gateway = "gateway"
        case smartPlug = "OHSPZ1CU01"
        case smartSwitchOne = "OHSSZL1Y01"
        case smartSwitchTwo = "OHSSZL2Y01"
        case smartSwitchThree = "OHSSZL3Y01"
        case smartSwitchFour = "OHSSZL4Y01"
        case sensor = "OHTHZD01"
        case doorSensor = "OHDSZ01"
        case pirSensor = "OHMSZ01"
        case smokeSensor = "OHSDZ01"
        case CCTBulb = "CCT"
        case RGBBulb = "RGBCCT"
        case GRCCT = "GRCCT"
        case GRRGBCCT = "GRRGBCCT"
        case camera178 = "178"
        case camera179 = "179"
        case camera180 = "180"
        case camera181 = "181"
        case camera182 = "182"
        case iGateWifi = "IGATE_WIFI"
        case ir = "IR"
        case irRemote = "REMOTE"
        case sceneSwitch = "HSS001"
        case curtain = "CMZ-W-101"
        case tuyaPlug = "TSP"
        case tuyaSocket = "TWS"
        case tuyaSwitch = "TS"
        
        enum Tuya: String {
            case pc = "pc" // tuya socket
            case kg = "kg" // tuya switch
            case cz = "cz" // tuya plug
            case wfBlePc = "wf_ble_pc"
            case wfKg = "wf_kg"
            case wfBleCz = "wf_ble_cz"
        }
        
        enum Wifi: String {
            case mesh12S = "EW12S"
            case mesh12SX = "EW12SX"
            case mesh12ST = "EW12ST"
            case mesh30SX = "EW30SX"
            case mesh30ST = "EW30ST"
            case mesh302S = "EW302S"
            case ont240H  = "GW240H"
            case ont240_H  = "GW240-H"
            case unknown  = "unknown"
            
            var imageName: String {
                switch self {
                    case .mesh12S:
                        return "ic_smartwifi_mesh"
                    case .mesh12SX:
                        return "ic_smartwifi_mesh"
                    case .mesh12ST:
                        return "ic_smartwifi_mesh"
                    case .mesh30SX:
                        return "ic_smartwifi_mesh"
                    case .mesh30ST:
                        return "ic_smartwifi_mesh"
                    case .mesh302S:
                        return "ic_smartwifi_mesh"
                    case .ont240H:
                        return "ic_smartwifi_ont"
                    case .ont240_H:
                        return "ic_smartwifi_ont"
                    case .unknown:
                        return "ic_smartwifi_igate"
                }
            }
        }
        
        init(withModelCode modelCode: String) {
            if modelCode.hasPrefix("OHSS") {
                self = .smartSwitchThree
            }
            self = DeviceType.init(rawValue: modelCode) ?? .camera176
        }
        
        func getImageName() -> String {
            switch self {
                case .sceneSwitch:
                    return "ic_scene_switch"
                case .curtain:
                    return "ic_curtain"
                case .camera176:
                    return "ic_camera_indoor"
                case .camera177:
                    return "ic_camera_outdoor"
                case .gateway:
                    return "Icon_gateway"
                case .smartPlug:
                    return "Icon_smart_plug"
                case .smartSwitchOne,
                        .smartSwitchTwo,
                        .smartSwitchThree,
                        .smartSwitchFour:
                    return "ic_smart_switch"
                case .sensor:
                    return "ic_temp_sensor"
                case .doorSensor:
                    return "ic_door_sensor"
                case .pirSensor:
                    return "ic_motion_sensor"
                case .smokeSensor:
                    return "ic_smoke_sensor"
                case .GRCCT:
                    return "ic_smart_light_group_transparent"
                case .GRRGBCCT:
                    return "ic_smart_light_group_rgb"
                case .CCTBulb:
                    return "ic_smart_light_transparent"
                case .RGBBulb:
                    return "ic_smart_light_rgb"
                case .camera178:
                    return "ic_camera_indoor"
                case .camera179:
                    return "ic_camera_outdoor"
                case .camera180:
                    return "ic_camera_indoor"
                case .camera181:
                    return "ic_camera_outdoor"
                case .camera182:
                    return "ic_camera_indoor"
                case .iGateWifi:
                    return "ic_smartwifi_igate"
                case .ir:
                    return "ic_ir_black"
                case .irRemote:
                    return ""
                case .tuyaSocket:
                    return "Icon_smart_plug"
                case .tuyaPlug:
                    return "Icon_smart_plug"
                case .tuyaSwitch:
                    return "ic_smart_switch"
            }
        }

        static func getPlaceHolderImage(modelCode: String?) -> UIImage? {
            guard let modelCode = modelCode,
                  let imageName = Constant.DeviceType(rawValue: modelCode)?.getImageName() else {
                return nil
            }
            return UIImage(named: imageName)
        }
        
        /// STC_ONEHOME-2972 `Cập nhật thời gian timeout cho quá trình Cập nhật phần mềm`
        func getTimeoutUpdate() -> CGFloat {
            var minuteTime: CGFloat = 1
            switch self {
                case .ir:
                    minuteTime = 10
                case .gateway:
                    minuteTime = 10
                case .camera176, .camera177: /// `Cam SJ`
                    minuteTime = 7
                case .camera178, .camera179, .camera180, .camera181, .camera182: /// `Cam Tech`
                    minuteTime = 3
                default:
                    minuteTime = 10
            }
            return minuteTime * 60.0
        }
        
        func getDeviceTypeName() -> String {
            switch self {
            case .ir:
                return "Smart IR Blaster"
            case .gateway:
                return "Gateway"
            default:
                return ""
            }
        }
        
        func isGatewayDevice() -> Bool {
            var gatewayDevices = [
                DeviceType.curtain.rawValue,
                DeviceType.sceneSwitch.rawValue
            ]
            gatewayDevices += (Constant.smartLightModelCodes + Constant.smartModelCodes + Constant.sensorModelCodes)
            return gatewayDevices.contains(self.rawValue)
        }
    }

    enum deviceType {
        case Door
        case Sensor
        case Switch
        case Plug
        case Pir
        case Smoke
        case Gateway
    }
    
    enum AlarmSoundType: String {
        case defautSound = "0_Alarm"
        case smoke = "3_Smoke"
        case open = "1_Open"
        case close = "2_Close"
        case trespasser = "4_Burglar"
        case welcome = "5_Welcoming"
    }
    
    enum SmartSwitchType: Int{
        case oneButton
        case twoButton
        case threeButton
    }
    
    enum AtrributeDeviceType: String{
        case traitOnOff = "traitOnOff"              // Bật/Tắt thiết bị (control + status) => true/false
        case traitTemperature = "traitTemperature"  // Giá trị Nhiệt độ (status) => double
        case traitHumidity = "traitHumidity"        // Giá trị độ ẩm (status) => percent 0-100
        case traitVoltage = "traitVoltage"
        case traitCurrent = "traitCurrent"
        case traitPower = "traitPower"
        case traitEnergy = "traitEnergy"
        case traitAlarmTrigger = "traitAlarmTrigger"    // Giá trị cảnh báo (status) => 0/1
        case traitOpenClose = "traitOpenClose"          // Giá trị đóng/mở (control + status) => 0/1
        case traitBatVoltage = "traitBatVoltage"
        case traitBatPercent = "traitBatPercent"        // Giá trị % Pin (status) => percent 0-100
        case traitBatLevel = "traitBatLevel"
        case traitGatewayStatus = "traitGatewayStatus"  // Giá trị trạng thái Gateway (status) => true/false
        case traitColor = "traitColor"                  // Giá trị màu sắc (control + status) => #ff00ff
        case traitTempColor = "traitTempColor"          // Giá trị độ ấm màu sắc (control + status) => percent 0-100
        case traitBrightness = "traitBrightness"        // Giá trị độ sáng (control + status) => percent 0-100
        case traitSaturation = "traitSaturation"        // Giá trị độ bão hoà (control + status) => percent 0-100
        case traitMode = "traitMode"
        case traitSetCurtainMotor = "traitSetCurtainMotor"  // Giá trị đóng/mở motor rèm, có thể quy về đóng mở (control + status) => 0/1
        case traitSetPercentage = "traitSetPercentage"      // Giá trị đóng/mở theo % (control + status) => percent 0-100
        case traitMotorSteering = "traitMotorSteering"      // Giá trị đảo chiều (control + status) => 0/1
    }
    
    enum NewDeviceType: String {
        case camera = "camera"
        case gateway = "GW"
        case smartPlug = "SP"
        case smartSwitch = "SS"
        case sensor = "TH"
        case doorSensor = "DS"
        case pirSensor = "MS"
        case smokeSensor = "SD"
        case smartLighting = "LD"
        case iGateWifi =  "IGATE_WIFI"
        case ir = "IR"
        case sceneSwitch = "HSS"
        case curtain = "CM"
        case irRemote = "REMOTE"
        case virtual = "VIRTUAL"
        case tuyaPlug = "TSP"
        case tuyaSocket = "TWS"
        case tuyaSwitch = "TS"
        
        init(typeCode: String) {
            
            switch typeCode {
            case NewDeviceType.camera.rawValue:
                self = .camera
            case NewDeviceType.gateway.rawValue:
                self = .gateway
            case NewDeviceType.smartPlug.rawValue:
                self = .smartPlug
            case NewDeviceType.smartSwitch.rawValue:
                self = .smartSwitch
            case NewDeviceType.sensor.rawValue:
                self = .sensor
            case NewDeviceType.doorSensor.rawValue:
                self = .doorSensor
            case NewDeviceType.pirSensor.rawValue:
                self = .pirSensor
            case NewDeviceType.smokeSensor.rawValue:
                self = .smokeSensor
            case NewDeviceType.smartLighting.rawValue:
                self = .smartLighting
            case NewDeviceType.iGateWifi.rawValue:
                self = .iGateWifi
            case NewDeviceType.ir.rawValue:
                self = .ir
            case NewDeviceType.curtain.rawValue:
                self = .curtain
            case NewDeviceType.sceneSwitch.rawValue:
                self = .sceneSwitch
            case NewDeviceType.irRemote.rawValue:
                self = .irRemote
            case NewDeviceType.tuyaPlug.rawValue:
                self = .tuyaPlug
            case NewDeviceType.tuyaSocket.rawValue:
                self = .tuyaSocket
            case NewDeviceType.tuyaSwitch.rawValue:
                self = .tuyaSwitch
            default:
                self = .camera
            }
        }
        
        func getResetDeviceImage() -> UIImage? {
            switch self {
            case .curtain:
                return UIImage(named: "ic_reset_curtain")
            case .sceneSwitch:
                return UIImage(named: "ic_reset_scene_switch")
            default:
                return nil
            }
        }
        
        func getImageName() -> String {
            switch self {
            case .camera:
                return "ic_camera_indoor"
            case .gateway:
                return "Icon_gateway"
            case .smartPlug:
                return "Icon_smart_plug"
            case .smartSwitch:
                return "ic_smart_switch"
            case .sensor:
                return "Icon_temp_humidity"
            case .doorSensor:
                return "ic_door_sensor"
            case .pirSensor:
                return "ic_motion_sensor"
            case .smokeSensor:
                return "ic_smoke_sensor"
            case .smartLighting:
                return "ic_smart_light_transparent"
            case .iGateWifi:
                return "ic_smartwifi_igate"
            case .ir:
                return "ic_ir_black"
            case .curtain:
                return "ic_curtain"
            case .sceneSwitch:
                return "ic_scene_switch"
            case .tuyaPlug:
                return "Icon_smart_plug"
            case .tuyaSocket:
                return "Icon_smart_plug"
            case .tuyaSwitch:
                return "ic_smart_switch"
            case .irRemote:
                return ""
            case .virtual:
                return ""
            }
        }
        
//        func getMessageAddDevice() -> String {
//        switch self {
//        case .sceneSwitch:
//            return dLocalized("KEY_PAIR_SCENE_SWITCH")
//        case .curtain:
//            return dLocalized("CURTAIN.RESET_INSTRUCTION_POWER")
//        case .camera:
//            return ""
//        case .gateway:
//            return dLocalized("KEY_PAIR_GATEWAY")
//        case .smartPlug:
//            return dLocalized("KEY_PAIR_PLUG")
//        case .smartSwitch:
//            return dLocalized("KEY_PAIR_SWITCH")
//        case .sensor:
//            return dLocalized("KEY_PAIR_THERMOSTAT")
//        case .doorSensor:
//            return dLocalized("KEY_PAIR_DOOR")
//        case .pirSensor:
//            return dLocalized("KEY_PAIR_MOTION")
//        case .smokeSensor:
//            return dLocalized("KEY_PAIR_SMOKE")
//        case .smartLighting:
//            return dLocalized("KEY_ADD_LIGHT_INSTRUCTION")
//        case .iGateWifi:
//            return dLocalized("KEY_PAIR_GATEWAY")
//        case .ir:
//            return dLocalized("KEY_PAIR_IR")
//        case .tuyaPlug:
//            return dLocalized("KEY_PAIR_PLUG")
//        case .tuyaSocket:
//            return dLocalized("KEY_PAIR_PLUG")
//        case .tuyaSwitch:
//            return dLocalized("KEY_PAIR_SWITCH")
//        case .irRemote:
//            return ""
//        case .virtual:
//            return ""
//        }
//        }

        func isGatewayDevice() -> Bool {
            switch self {
            case .curtain, .doorSensor, .pirSensor, .sceneSwitch, .sensor, .smartLighting, .smartPlug, .smartSwitch, .smokeSensor:
                return true
            default:
                return false
            }
        }
    }
    
    static let lightModelCodes = [DeviceType.CCTBulb.rawValue, DeviceType.RGBBulb.rawValue]
    static let groupModelCodes = [DeviceType.GRCCT.rawValue, DeviceType.GRRGBCCT.rawValue]
    static let sensorModelCodes = [DeviceType.doorSensor.rawValue,
                                   DeviceType.pirSensor.rawValue,
                                   DeviceType.sensor.rawValue,
                                   DeviceType.smokeSensor.rawValue]
    static let smartModelCodes = [DeviceType.smartPlug.rawValue,
                                   DeviceType.smartSwitchOne.rawValue,
                                   DeviceType.smartSwitchTwo.rawValue,
                                   DeviceType.smartSwitchThree.rawValue,
                                   DeviceType.smartSwitchFour.rawValue]
    static let switchHasChildModelCodes = [DeviceType.smartSwitchTwo.rawValue, DeviceType.smartSwitchThree.rawValue, DeviceType.smartSwitchFour.rawValue]
    static let deviceHasChildModelCodes = groupModelCodes + switchHasChildModelCodes
    static let smartLightModelCodes = lightModelCodes + groupModelCodes
    static let cameraVNPTCodes = [DeviceType.camera178.rawValue, DeviceType.camera179.rawValue ,DeviceType.camera180.rawValue, DeviceType.camera181.rawValue, DeviceType.camera182.rawValue ]
    static let cameraKHJCodes = [DeviceType.camera176.rawValue, DeviceType.camera177.rawValue]
    
    static let RGBLightsAndLightGroups = [DeviceType.RGBBulb.rawValue, DeviceType.GRRGBCCT.rawValue]
    static let CCTLightsAndLightGroups = [DeviceType.CCTBulb.rawValue, DeviceType.GRCCT.rawValue]
    
//    static let deviceControlLightModelCodes = [DeviceControlType.smartLightCCT.rawValue,
//                                               DeviceControlType.smartLightRGBCCT.rawValue]
//    static let deviceControlGroupModelCodes = [DeviceControlType.smartLightGroupCCT.rawValue,
//                                               DeviceControlType.smartLightGroupRGBCCT.rawValue,
//                                               DeviceControlType.smartLightGroup.rawValue]
//    static let deviceControlSmartLightModelCodes = deviceControlLightModelCodes + deviceControlGroupModelCodes
    
    static let appIdInAppstore = "id1523250706"
    
    static let threadNamePrefix = "vn.vnpt.ONEHome.thread."
    
//    static var wifiInfos: [(uid: String, wifiEntity: WifiEntity)] = []
//    
//    static let camereDefaultConfigs = DeviceConfig(volumes: "100",
//                                          timezone: "420",
//                                          timezone_id: "99",
//                                          timezone_value: "UTC+07",
//                                          watermark_mode: "off",
//                                          record_mode: "1",
//                                          sleep_mode: "1",
//                                          wifi_ssid: wifiName,
//                                          motion_detection: "off",
//                                          alarm_volume: "on",
//                                          alarm_to_phone: "on",
//                                          motion_detection_notification: "on")
    
    // Name, type, Image path
    static let cameraTypeMapper  = [
        DeviceType.camera176: ("Camera", "Indoor camera", "Icon_camera_indoor"),
        DeviceType.camera177: ("Camera", "Outdoor camera", "Icon_camera_outdoor"),
        DeviceType.camera178: ("Camera", "Indoor camera", "Icon_camera_indoor"),
        DeviceType.camera179: ("Camera", "Outdoor camera", "Icon_camera_outdoor"),
        DeviceType.camera180: ("Camera", "Indoor camera", "Icon_camera_indoor_180"),
        DeviceType.camera181: ("Camera", "Outdoor camera", "Icon_camera_outdoor_181"),
        DeviceType.camera182: ("Camera", "Indoor camera", "Icon_camera_outdoor_182"),
    ]
    
    //MARK: ONEHome 3.0 VNPT Camera
    struct OHCamera {
        static let maximumVideoPlaybackDuration = 900000 // Tính theo mili giây
        static let maximumVideoRecord           = 3600 // Tính theo giây
        static let videoRecordHolder            = "VNPTCamera_videoRecord"
        static let audioRecordHolder            = "VNPTCamera_audioRecord"
        static let videoM3u8Holder              = "VNPTCamera_videoM3u8"
        
        struct CameraUID {
            static let cameraSimulator = "PPCS-018817-MRLJR"
            static let cameraReal = "PPCS-018820-FTFUK"
            static let cameraRealNew = "VNT-000173-FTSEZ"
            static let cameraSDK = "PPCS-018823-KCKMC"
            
            static let cameraSDK1 = "PPCS-018828-PJTYM"
            static let cameraSDK2 = "PPCS-018829-GKKWB"
        }
        
        struct CameraPassword {
            static let cameraSimulator = "default"
            static let cameraReal = "default"
            static let cameraRealNew = "vnpt@123"
        }
        
        struct CameraType {
            
        }
        
        struct AudioFormat {
            static let audioRate = Double(8000)
            static let audioChannel = 1
            static var bufferSize = 256
            static var bufferByteSize = MemoryLayout<Float>.size * 256
        }
        
        enum StatusFirmware: Int32 {
            case todo = 0
            case inProgress = 1
            case failed = 2
            case succeeded = 3
        }
    }
    
    struct Subscriptions {
        static let hotline = "19001525"
        ///Trạng thái gói cước khi chưa đăng ký
        ///0: mới,
        ///1: hoạt động,
        ///2: tạm dừng,
        ///3: hủy
        enum UnregisteredActive: Int {
            case new = 0
            case active = 1
            case pending = 2
            case cancelled = 3
        }
        
        ///Trạng thái gói cước khi đã đăng ký
        ///0: đã hủy,
        ///1: kích hoạt,
        ///2: hết hạn,
        ///3: gia hạn ko thành công,
        ///4: đăng ký thất bại,
        ///5: chờ xác nhận
        ///6: tạm ngưng
        enum RegisteredActive: Int {
            case cancelled = 0
            case active = 1
            case expired = 2
            case extendFailed = 3
            case registerFailed = 4
            case processing = 5
            case suspended = 6
        }
        
        enum CloudType: Int {
            case google = 1
            case alibaba = 2
            
            var name: String {
                switch self {
                    case .alibaba:
                        return "alibabaCloud"
                    case .google:
                        return "googleCloud"
                }
            }
        }
    }
    
//    static let listMeshDeviceType : [OHWifiDeviceType?] = [.mre , .cap , OHWifiDeviceType.none]
    
    //MARK: - ONEHome IR
    struct OHIRRemote {
        static let singleCommandTransactionID: String = "ir_remote_single_command."
        static let changeLearningStatusTransactionID: String = "ir_change_learning_status."
        static let countTopTemplate: Int = 3
    }

    enum OHIRRemoteMessageID: String {
        case singleCommand = "single_control_ir_device"
        case havCommand = "hav_control_ir_device"
        case changeLearnStatus = "change_learning_status"
    }
    
    static let listDeviceTypeNotHomeSharing : [NewDeviceType] = [.gateway, .iGateWifi, .ir, .curtain, .virtual, .sceneSwitch]
    
    static let listDeviceModelNotHomeSharing : [DeviceType] = [.tuyaPlug, .tuyaSocket, .tuyaSwitch]
        
    static let maxChildSwitch = 4 // Show tối đa 4 công tắc trên device cell
    
    static let listDeviceTypeInHomeSharing : [NewDeviceType]  = [ .camera , .smartPlug, .smartSwitch, .sensor , .doorSensor, .pirSensor, .smokeSensor , .smartLighting]
    
    static let listExpandableCellModels: [DeviceType] = [.smartSwitchTwo, .smartSwitchThree, .smartSwitchFour, .tuyaSocket, .tuyaSwitch, .tuyaPlug]
    
    static let listTuyaDevice: [DeviceType] = [.tuyaPlug, .tuyaSocket, .tuyaSwitch]
    
    struct HTTPHeaderKey {
        static let userAgent = "User-Agent"
        static let acceptLanguage = "Accept-Language"
        static let appKey = "app-key"
        static let homeId = "homeId"
    }
}



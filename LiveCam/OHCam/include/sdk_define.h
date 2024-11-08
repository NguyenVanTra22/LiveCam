#ifndef SDK_DEFINE_H
#define SDK_DEFINE_H

#define SDK_SUCCESS 	0
#define SDK_FAIL	1
#define SDK_DUPLICATE	2
#define SDK_ONGOING	4



#define SDK_DEVICE_ID_LEN 128
#define SDK_RECEIVE_BUF_LEN	2048
#define SDK_AUDIO_DECODE_LEN	4096
#define SDK_VIDEO_DECODE_LEN	1024000


#define SDK_VIDEO_TYPE 0 
#define SDK_AUDIO_TYPE 1



#define SDK_API_NOT_INITIALIZED 	(-1)
#define SDK_API_ALREADY_INITIALIZED 	(-2)
#define SDK_API_TIME_OUT 		(-3)
#define SDK_API_INVALID_ID 		(-4)
#define SDK_API_INVALID_PARAMETER 	(-5)
#define SDK_API_DEVICE_NOT_ONLINE 	(-6)
#define SDK_API_FAIL_TO_RESOLVE_NAME 	(-7)
#define SDK_API_INVALID_PREFIX 		(-8)
#define SDK_API_ID_OUT_OF_DATE 		(-9)
#define SDK_API_NO_RELAY_SERVER_AVAILABLE 	(-10)
#define SDK_API_INVALID_SESSION_HANDLE 		(-11)
#define SDK_API_SESSION_CLOSED_REMOTE 		(-12)
#define SDK_API_SESSION_CLOSED_TIMEOUT 		(-13)
#define SDK_API_SESSION_CLOSED_CALLED 		(-14)
#define SDK_API_REMOTE_SITE_BUFFER_FULL 	(-15)
#define SDK_API_USER_LISTEN_BREAK 		(-16)
#define SDK_API_MAX_SESSION 			(-17)
#define SDK_API_UDP_PORT_BIND_FAILED 		(-18)
#define SDK_API_USER_CONNECT_BREAK 		(-19)
#define SDK_API_SESSION_CLOSED_INSUFFICIENT_MEMORY (-20)
#define SDK_API_INVALID_APILICENSE 		(-21)
#define SDK_API_FAIL_TO_CREATE_THREAD 		(-22)



#define SDK_API_SESSION_ALREADY_CONNECTED	(-128)
#define SDK_API_SESSION_NOT_EXISTENCE		(-129)	
#define SDK_API_DEVICE_REQUEST_EXPIRED		(-130) 
#define SDK_API_DEVICE_INVALID_RSP_PARAM	(-131)


#define SDK_API_DEVICE_EXEC_CMD_FAIL            (-140)    // thực thi lỗi
#define SDK_API_DEVICE_INVALID_PARAM            (-141)    // sai kiểu dữ liệu đầu vào
#define SDK_API_DEVICE_OUT_OF_RANGE                (-142)    // ngoài khoảng giá trị cho phép
#define SDK_API_DEVICE_EXEPTION                    (-143)    // ngoại lệ
#define SDK_API_DEVICE_USERNAME_INCORRECT       (-144)    // sai username
#define SDK_API_DEVICE_PASSWD_INCORRECT         (-145)    // sai pwd



#define SDK_COUNTER_VIDEO_BYTE_RECV_ID		0x01
#define SDK_COUNTER_VIDEO_PACKAGE_RECV_ID	0x02
#define SDK_COUNTER_AUDIO_BYTE_RECV_ID		0x03
#define SDK_COUNTER_AUDIO_PACKAGE_RECV_ID	0x04


#define SDK_API_SUCCESSFUL 			SDK_SUCCESS
#define SDK_API_FAIL				SDK_FAIL
#define SDK_EXPIRED	SDK_API_DEVICE_REQUEST_EXPIRED

enum sdkAudioCodec
{
	SDK_DEFAULT_CODEC = 0 ,
	SDK_PCM16_CODEC = 0,
	SDK_PCMA_CODEC,
	SDK_PCMU_CODEC
};


enum eCommandType
{
	SDK_CONNECT_COMMAND=1,
  	SDK_DISCONNECT_COMMAND,
  	SDK_RECONNECT_COMMAND,
	SDK_SET_TIMEZONE_COMMAND,
	SDK_GET_VIDEO_QUALITY_COMMAND,
	SDK_SET_PASSWORD_COMMAND,
	SDK_SET_VIDEO_STORAGE_MODE_COMMAND,
	SDK_FORMAT_SDCARD_COMMAND,
	SDK_GET_DEVICEINFO_COMMAND, //SDK_GET_DEVICEINFO_COMMAND,
	SDK_GET_RECORD_VIDEO_QUALITY_COMMAND,
	SDK_REGISTER_ACTIVE_PUSH_LISTENER_COMMAND,
	SDK_UN_REGISTER_ACTIVE_PUSH_LISTENER_COMMAND,
	SDK_START_RECV_AUDIO_COMMAND,
	SDK_CHECK_DEVICE_STATUS_COMMAND,
	SDK_SET_DEVICE_CAM_STATUS_COMMAND,
	SDK_SET_DEVICE_ALARM_VOLUME_COMMAND,
	SDK_SET_PHP_SERVER_COMMAND,
	SDK_START_RECV_VIDEO_COMMAND,
	SDK_GET_FLIPPING_COMMAND,
	SDK_SET_FLIPPING_COMMAND,
	SDK_START_SEND_AUDIO_COMMAND,
	SDK_SET_RUN_COMMAND,
	SDK_SET_VIDEO_QUALITY_COMMAND,
	SDK_GET_DEVICE_SPEAKER_VOLUME_COMMAND,
	SDK_GET_DEVICE_MIC_VOLUME_COMMAND,
	SDK_SET_DEVICE_SPEAKER_VOLUME_COMMAND,
	SDK_SET_DEVICE_MIX_VOLUME_COMMAND,
	SDK_SET_ONOFF_MOTION_DETECTION_COMMAND,
	SDK_SET_SENSI_MOTION_DETECTION_COMMAND,
	SDK_SET_NOTI_FREQ_MOTION_DETECTION_COMMAND,
	SDK_SET_SPEAKER_MOTION_DETECTION_COMMAND,
	SDK_SET_ZONE_MOTION_DETECTION_COMMAND,
	SDK_SET_SCHEDULE_MOTION_DETECTION_COMMAND,
	SDK_GET_MAC_IP_COMMAND,
	SDK_SET_URL_UPGREADE_FW_COMMAND,
	SDK_GET_VIDEO_RECORD_QUALITY_COMMAND,
	SDK_PLAY_SD_VIDEO_COMMAND,
	SDK_GET_ALL_VIDEO_TIME_COMMAND,
	SDK_PUSH_VIDEO_UPDATE_COMMAND,
	SDK_LOSS_CONNECTION_COMMAND,
	SDK_RES_FORMAT_SDCARD_STATUS_COMMAND,
	SDK_ON_OFF_MIC_COMMAND,
	SDK_START_STOP_PLAYBACK_COMMAND,
	SDK_UPDATE_FIRMWARE_COMMAND,
	SDK_SET_VIDEO_RECORD_TYPE_COMMAND,
	SDK_GET_LIST_RECORD_SCHEDULE_COMMAND,
	SDK_UPDATE_LIST_RECORD_SCHEDULE_COMMAND,
	SDK_GET_VIDEO_RECORD_TYPE_COMMAND,
	SDK_LIST_MD_NOTI_COMMAND,
	SDK_ZONE_MD_NOTI_COMMAND,
	SDK_SET_VIDEO_RECORD_QUALITY_COMMAND,
	SDK_CHANGE_FLIP_COMMAND,
	SDK_GET_SESSION_STATISTIC_COMMAND,
	SDK_RECORD_LIVEVIEW_COMMAND,
	SDK_CHANGE_STORAGE_MODE_RECORD_QUALITY_COMMAND,
	SDK_ONOFF_HUMAN_DETECT_COMMAND,
	SDK_RESET_PTZ_COMMAND,
	SDK_RES_NOTIFY_PTZ_STATUS_COMMAND,
	SDK_GET_WIFI_SCAN_COMMAND,
	SDK_SET_WDR_COMMAND,
	SDK_GET_WDR_COMMAND,
	SDK_GET_RSSI_COMMAND,
	SDK_SET_WIFI_INFO_COMMAND,
	SDK_SET_ONOFF_MOTION_NOTIFICATION_COMMAND,
    SDK_ONOFF_SMART_TRACKING_COMMAND,
	SDK_DEFAULT_COMMAND
};

#endif



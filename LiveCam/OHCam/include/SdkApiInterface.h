#ifndef SDKAPIINTERFACE_H
#define SDKAPIINTERFACE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/time.h>
#include <stdint.h> 
#include <stdbool.h>
#include <libavutil/frame.h>

typedef int (*NotifMediaDataFp) (int , int, char*, int, int, int) ;
typedef int (*NotifVideoMediaDataFp) (int , int, AVFrame*, int, int, int) ;
typedef int (*NotifCommandCallBackFp) (int , int, int ) ;
typedef int (*NotifMessageFp) (int , int, int, int ) ;
typedef int (*NotifMessageWithBodyFp) (int , int, int, int, char* body, int len ) ; //sessionID, command, -1, status, body, len


#ifdef __cplusplus
extern "C" {
#endif


#define SDK_DEVICE_PASSWD_LEN 128

// typedef result callback function
typedef void (*ResultCb) (int, int, int);										// Hàm callback tr? l?i sessionHandle, mã l?i
typedef void (*ResultCb_i) (int, int, int, int);									// Hàm callback tr? l?i sessionHandle, mã l?i và thông in "int" kèm theo
typedef void (*ResultCb_ii) (int, int, int, int, int);							// Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "int", "int", "int" kèm theo
typedef void (*ResultCb_iiiss) (int, int, int, int, int, char*, char*, char*);	// Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "int", "int", "int", "int", "char*", "char*" kèm theo
typedef void (*ResultCb_b) (int, int, int, bool);								// Hàm callback tr? l?i sessionHandle, mã l?i và thông in "bool" kèm theo
typedef void (*ResultCb_s) (int, int, int, char*);								// Hàm callback tr? l?i sessionHandle, mã l?i và thông in "char*" kèm theo
typedef void (*ResultCb_bi) (int, int, int, bool, int);							// Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "bool", "int" kèm theo
typedef void (*ResultCb_u) (int, int, int, int);									// Hàm callback tr? l?i sessionHandle, mã l?i và thông in "int" kèm theo
typedef void (*ResultCb_llll) (int, int, int, int64_t , int64_t, int64_t, int64_t );//int sessionID, int commandID, int status, int64_t  totalByte, int64_t totalPackage, int64_t totalBytePs, int64_t totalPackagePs

// typedef notify callback function
typedef void (*NotifyCb) (int, int);										// Hàm callback tr? l?i sessionHandle và thông in "int" kèm theo
typedef void (*NotifyCb_s) (int, char*);									// Hàm callback tr? l?i sessionHandle và thông in "char*" kèm theo

//////////////////////////////////////////////// Khai báo các hàm SDK API Interface //////////////////////////////////////////////

const char*	SDK_API_getVersion(); 
uint32_t SDK_API_init(char* initString);
void SDK_API_setVideoCallback(NotifVideoMediaDataFp fp ) ;
void SDK_API_setAudioCallback(NotifMediaDataFp fp ) ;
void SDK_Notify_setNotifyCallback(NotifMessageFp fp ) ;
void SDK_API_setMediaCallback(NotifMediaDataFp fp ) ; 
int SDK_API_liveViewRecord (int sessionHandle, int action , ResultCb_i resultCb);
void SDK_Notify_setNotifyWithBodyCallback(NotifMessageWithBodyFp fp );

int SDK_API_updateFW (int sessionHandle, char* ota_server, ResultCb resultCb);

int SDK_API_sendAudio (int sessionId, uint8_t* buf, int len, int codec );

int SDK_API_getStatistic (int sessionHandle, ResultCb_llll resultCb);

int SDK_API_connect (int instanceID, char* cameraUID, char* password, char bLanSearch ,ResultCb_i resultCb) ;//use ResultCb_i bLanSearch(LTE:0, default:0x7A)

int SDK_API_reconnect (int sessionHandle, char* cameraUID, char* password, char bLanSearch, ResultCb_i resultCb); //use ResultCb_i  bLanSearch(LTE:0, default:0x7A)

int SDK_API_disconnect (int sessionHandle, ResultCb resultCb);  //use ResultCb

int SDK_API_getVideoQuality (int sessionHandle, ResultCb_i resultCb);		// use ResultCb_i

int SDK_API_getDeviceInfo (int sessionHandle, ResultCb_s resultCb);	// ResultCb_s callback

int SDK_API_getRecordVideoQuality (int sessionHandle, ResultCb_i resultCb);	// ResultCb_i callback

int SDK_API_registerActivePushListener (int sessionHandle, void *resultCb);	// ResultCb_i callback

int SDK_API_unRegisterActivePushListener (int sessionHandle, void *resultCb);	// ResultCb_i callback

int SDK_API_startRecvAudio (int sessionHandle, bool enable, ResultCb resultCb);	// ResultCb callback

int SDK_API_checkDeviceStatus (int sessionHandle, void *resultCb);	// ResultCb_i callback

int SDK_API_setDeviceCameraStatusWithOpen (int sessionHandle, bool status, ResultCb resultCb);	// ResultCb callback

int SDK_API_setPassword (int sessionHandle, char* oldPassword, char* newPassword, ResultCb resultCb);	// ResultCb callback

int SDK_API_setVideoStorageMode (int sessionHandle, int mode, ResultCb resultCb);	// ResultCb callback

int SDK_API_setDeviceAlarmVolume (int sessionHandle, bool isOpen, ResultCb resultCb);	// ResultCb callback

int SDK_API_setPHPServer (int sessionHandle, char* ipAddress, ResultCb resultCb);	// ResultCb callback

int SDK_API_setTimezone (int sessionHandle, int timeZone, ResultCb resultCb);	// use ResultCb

int SDK_API_startRecvVideo (int sessionHandle, bool isReceive, ResultCb resultCb);	// ResultCb callback

int SDK_API_getFLipping (int sessionHandle, ResultCb_i resultCb);	// ResultCb_i callback

int SDK_API_setFLipping (int sessionHandle, bool isFlipped, ResultCb resultCb);	// ResultCb callback

int SDK_API_startSendAudio (int sessionHandle, bool isOn, ResultCb resultCb);	// ResultCb callback

int SDK_API_setRun (int sessionHandle, int left, int right, int up, int down, ResultCb_s resultCb); // ResultCb callback

int SDK_API_setVideoQuality (int sessionHandle, int mode, int framerate, ResultCb resultCb); // ResultCb callback

int SDK_API_formatSdcard (int sessionHandle, ResultCb resultCb); // ResultCb callback

int SDK_API_getDeviceSpeakerVolume (int sessionHandle, ResultCb_i resultCb);	// ResultCb_i callback

int SDK_API_getDeviceMicVolume (int sessionHandle, ResultCb_i resultCb);	// ResultCb_i callback

int SDK_API_setDeviceSpeakerVolume (int sessionHandle, int capture_volume, int playback_volume,  ResultCb resultCb);	// ResultCb callback

int SDK_API_setDeviceMixVolume (int sessionHandle, int status, ResultCb resultCb);	// ResultCb callback

int SDK_API_setOnOffMotionDetection (int sessionHandle, bool md, ResultCb resultCb);	// ResultCb callback

int SDK_API_setSensiMotionDetection (int sessionHandle, int sensi, ResultCb resultCb);	// ResultCb callback

int SDK_API_setNotiFreqMotionDetection (int sessionHandle, int noti_freq, ResultCb resultCb);	// ResultCb callback

int SDK_API_setSpeakerMotionDetection (int sessionHandle, bool speaker, ResultCb resultCb);	// ResultCb callback

int SDK_API_setZoneMotionDetection (int sessionHandle, char* jsonZone, ResultCb resultCb); // ResultCb callback

// int SDK_API_setScheduleMotionDetection (int sessionHandle, bool fulltime, char* schedulesStruct, ResultCb resultCb);	// ResultCb callback

int SDK_API_setScheduleMotionDetection (int sessionHandle, char* motionJsonSchedule, ResultCb resultCb);

int SDK_API_getMacIp (int sessionHandle, ResultCb_s resultCb);	// ResultCb_s callback

int SDK_API_setUrlServer (int sessionHandle, char* ntp_server, char* cloud_server, char* ota_server, char* event_server, ResultCb resultCb);	// ResultCb callback

int SDK_API_playSDVideo (int sessionHandle, char*  fileName, long seekTo, ResultCb resultCb);	// ResultCb callback  // tr?ng thái tr? l?i sau

int SDK_API_getAllVedioTime (int sessionHandle, int begin, int end, int type, int page,  ResultCb_s resultCb); 	// ResultCb_s callback			// tr?ng thái tr? l?i sau

int SDK_API_onOffMic (int sessionHandle, bool enable, ResultCb resultCb);	// ResultCb callback

int SDK_API_startStopPlayback (int sessionHandle, bool enable, ResultCb resultCb);	// ResultCb callback

int SDK_API_setVideoRecordType (int sessionHandle, char* jsonRecordType, ResultCb resultCb);	// ResultCb callback

int SDK_API_getListRecordSchedule (int sessionHandle, ResultCb_s resultCb);	// ResultCb callback

int SDK_API_updateListRecordSchedule (int sessionHandle, char* recordSchedule, ResultCb resultCb);	// ResultCb callback

int SDK_API_getVideoRecordType (int sessionHandle, ResultCb_s resultCb);	// ResultCb callback

int SDK_API_getListMDNotification (int sessionHandle, ResultCb_s resultCb);	// ResultCb callback

int SDK_API_getZoneMDNotification (int sessionHandle, ResultCb_s resultCb);	// ResultCb callback

int SDK_API_setVideoRecordQuality (int sessionHandle, char* recordQuality, ResultCb resultCb);

int SDK_API_changeStorageModeRecordQuality (int sessionHandle, char* changeMode, ResultCb resultCb);

int SDK_API_onOffHumanDetect (int sessionHandle, char* msgOnOffHumanDetect, ResultCb resultCb);

int SDK_API_resetPtz (int sessionHandle, char* msgResetPtz, ResultCb resultCb); // ResultCb callback

int SDK_API_getRssi (int sessionHandle,  ResultCb_i resultCb) ;// session, command_id, status, signal

int SDK_API_getWdr(int sessionHandle,  ResultCb_i resultCb);//session, command_id, status, wdr (1: true, 0: false )

int SDK_API_getWifiList(int sessionHandle,  ResultCb_s resultCb);//session, command_id, status, wifi list

int SDK_API_setWdr(int sessionHandle,int enable ,  ResultCb resultCb) ; //session, command_id, status,

int SDK_API_setWifi(int sessionHandle,char* ssid, char* pass, int manual,  ResultCb resultCb)  ; //session, command_id, status,

int SDK_API_checkOnlineStatus (int instanceID, char* cameraUID ) ;

int SDK_API_setOnOffMotionNotification (int sessionHandle, int mdNotif, ResultCb resultCb);////session, command_id, status,

int SDK_API_onOffSmartTracking (int sessionHandle, bool enable, ResultCb resultCb);

//////////////////////////////////////////////// Khai báo các hàm Notify //////////////////////////////////////////////
void SDK_Notify_videoQualityUpdate(int sessionHandle, int status, int videoQualityUpdate);

void SDK_Notify_cameraLossConnect(int sessionHandle, int status);

void SDK_Notify_formatSDCardStatus(int sessionHandle, int status);

void SDK_Notify_ptzStatus(int sessionHandle, int status);

//void SDK_Notify_changeFlipStatus(int sessionHandle, int status);
void SDK_Notify_changeFlipStatus(int sessionHandle, int status, char* msg, int len );
#ifdef __cplusplus
}
#endif
#endif

//
//  VNPTCamApi.h
//  OneHome
//
//  Created by ThiemJason on 27/02/2022.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../include/sdk_define.h"
#import "../../include/SdkApiInterface.h"

NS_ASSUME_NONNULL_BEGIN
//MARK: - Callback
/** Test */
typedef void(^resultBlock)(int reponseInt);
/** Audio */
typedef void(^audioResponse)(int sessionID, char * buffer, int bufferLength, int seq, int timeStamp);
/** Video */
typedef void(^videoResponse)(int sessionID, AVFrame * avFrame, int frameLength, int seq, int timeStamp);
/** Media ( Sử dụng khi record ) */
typedef void(^mediaResponse)(int sessionID, int type, char * buffer, int bufferLength, int seq, int timeStamp);
/** Notify callback */
typedef void(^notifyResponse)(int sessionID, int commandID, int errorCode, int extraInt);
/** Notify body callback */
typedef void(^notifyBodyResponse)(int sessionID, int commandID, int temp, int errorCode, NSString* body , int len);  //sessionID, command, -1, status, body, len
/** ResultCb callback trả về sessionHandle, mã lỗi */
typedef void(^resultCb_Response)(int, int, int);
/** ResultCbi callback trả về sessionHandle, mã lỗi và thông in "int" kèm theo */
typedef void(^resultCb_i_Response)(int, int, int, int);
/** ResultCbi // Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "int", "int", "int" kèm theo */
typedef void(^resultCb_ii_Response)(int, int, int, int, int);
/** // Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "int", "int", "int", "int", "char*", "char*" kèm theo */
typedef void(^resultCb_iiiss_Response)(int, int, int, int, int, NSString*, NSString*, NSString*);
/** Hàm callback tr? l?i sessionHandle, mã l?i và thông in "char*" kèm theo */
typedef void(^resultCb_s_Response)(int, int, int, NSString*);
/** Hàm callback tr? l?i sessionHandle, mã l?i và thông in long kèm theo */
typedef void(^resultCb_llll_Response)(int, int, int, int64_t, int64_t, int64_t, int64_t);
/** Command response 0: Success Anything else: Faliure */
typedef void (^command_Result)(int);

@interface OHCamSDKApi : NSObject
//MARK: - sharedInstance
+ (instancetype)new __attribute__((unavailable("please initialize by use .share or .share()")));
- (instancetype)init __attribute__((unavailable("please initialize by use .share or .share()")));
+ (instancetype)sharedInstance;

@property (nonatomic,copy) resultBlock resultCallback;
@property (nonatomic,copy) audioResponse audioResponse;
@property (nonatomic,copy) videoResponse videoResponse;
@property (nonatomic,copy) mediaResponse mediaResponse;
@property (nonatomic,copy) notifyResponse notifyResponse;
@property (nonatomic,copy) notifyBodyResponse notifyBodyResponse;

@property (nonatomic,copy) resultCb_Response resultCb_Response;
@property (nonatomic,copy) resultCb_s_Response resultCb_s_Response;
@property (nonatomic,copy) resultCb_i_Response resultCb_i_Response;
@property (nonatomic,copy) resultCb_ii_Response resultCb_ii_Response;
@property (nonatomic,copy) resultCb_iiiss_Response resultCb_iiiss_Response;
@property (nonatomic,copy) resultCb_llll_Response resultCb_llll_Response;
//MARK: - Method
- (void) initApi: (NSString *) initString;
- (void) connectCamera: (int) instanceID : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult;
- (void) disconnectCamera: (int) sessionHandle : (command_Result) cmdResult;
- (void) reconnectCamera: (int) sessionHandle : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult;
- (void) getVideoQuality: (int) sessionHandle : (command_Result) cmdResult;
- (void) getDeviceInfo: (int) sessionHandle : (command_Result) cmdResult;
- (void) getRecordVideoQuality: (int) sessionHandle : (command_Result) cmdResult; // ResultCb_i callback
- (void) startRecvAudio: (int) sessionHandle : (bool) enable : (command_Result) cmdResult;
- (void) startRecvVideo: (int) sessionHandle : (bool) isReceive : (command_Result) cmdResult;
- (void) setPassword: (int) sessionHandle : (NSString*) oldPassword : (NSString*) newPassword : (command_Result) cmdResult;
- (void) startSendAudio: (int) sessionHandle : (bool) isOn : (command_Result) cmdResult;
- (void) sendAudio: (int) sessionHandle : (uint8_t*) buffer : (int) bufferLength : (int) codec : (command_Result) cmdResult;
- (void) setMediaCallback;
- (void) setVideoCallback;
- (void) setAudioCallback;
- (void) setNotifyCallback;
- (void) setNotifyCallbackWithBody;
- (void) setVideoStorageMode: (int) sessionHandle : (int) mode : (command_Result) cmdResult; // ResultCb callback
- (void) setDeviceAlarmVolume: (int) sessionHandle : (bool) isOpen : (command_Result) cmdResult; // ResultCb callback
- (void) setPHPServer: (int) sessionHandle : (NSString*) ipAddress : (command_Result) cmdResult; // ResultCb callback
- (void) setTimezone: (int) sessionHandle : (int) timeZone : (command_Result) cmdResult; // use ResultCb
- (void) getFLipping: (int) sessionHandle : (command_Result) cmdResult; // ResultCb_i callback
- (void) setFLipping: (int) sessionHandle : (bool) isFlipped : (command_Result) cmdResult; // ResultCb
- (void) setRun: (int) sessionHandl : (int) left : (int) right : (int) up : (int) down : (command_Result) cmdResult;// ResultCb callback
- (void) setVideoQuality: (int) sessionHandle : (int) mode : (int) framerate : (command_Result) cmdResult;// ResultCb callback
- (void) formatSdcard: (int) sessionHandle : (command_Result) cmdResult; // ResultCb callback
- (void) getDeviceSpeakerVolume: (int) sessionHandle : (command_Result) cmdResult;    // ResultCb_i callback
- (void) getDeviceMicVolume: (int) sessionHandle : (command_Result) cmdResult; // ResultCb_i callback
- (void) setDeviceSpeakerVolume: (int) sessionHandle : (int) capture_volume : (int) playback_volume : (command_Result) cmdResult; // ResultCb callback
- (void) setDeviceMixVolume: (int) sessionHandle : (int) status : (command_Result) cmdResult;    // ResultCb callback
- (void) setOnOffMotionDetection: (int) sessionHandle : (bool) md : (command_Result) cmdResult;    // ResultCb callback
- (void) setSensiMotionDetection: (int) sessionHandle : (int) sensi : (command_Result) cmdResult;    // ResultCb callback
- (void) setNotiFreqMotionDetection: (int) sessionHandle : (int) noti_freq : (command_Result) cmdResult;    // ResultCb callback
- (void) setSpeakerMotionDetection: (int) sessionHandle : (bool) speaker : (command_Result) cmdResult;    // ResultCb callback
- (void) setZoneMotionDetection: (int) sessionHandle : (NSString*) jsonZone : (command_Result) cmdResult;    // ResultCb callback
- (void) setScheduleMotionDetection: (int) sessionHandle : (NSString*) schedulesStruct : (command_Result) cmdResult; // ResultCb callback
- (void) setUrlServer: (int) sessionHandle : (NSString*) ntp_server : (NSString*) cloud_server : (NSString*) ota_server : (NSString*) event_server : (command_Result) cmdResult; // ResultCb callback
- (void) startUpdateFirmware: (int) sessionHandle : (NSString*) url : (command_Result) cmdResult; // ResultCb callback
- (void) playSDVideo: (int) sessionHandle : (NSString*) fileName : (long) seekTo : (command_Result) cmdResult; // ResultCb callback  // tr?ng thái tr? l?i sau
- (void) getAllVedioTime: (int) sessionHandle : (int) begin : (int) end : (int) type : (int) page : (command_Result) cmdResult; // ResultCb_s callback            // tr?ng thái tr? l?i sau
- (void) onOffMic: (int) sessionHandle : (bool) enable : (command_Result) cmdResult;    // ResultCb callback
- (void) startStopPlayback: (int) sessionHandle : (bool) enable : (command_Result) cmdResult; // ResultCb callback
- (void) setVideoRecordType: (int) sessionHandle : (NSString*) jsonRecordType : (command_Result) cmdResult;
- (void) setVideoRecordQuality: (int) sessionHandle : (NSString*) jsonRecordQuality : (command_Result) cmdResult;
- (void) getVideoRecordType: (int) sessionHandle : (command_Result) cmdResult;
- (void) getListRecordSchedule: (int) sessionHandle : (command_Result) cmdResult;
- (void) updateListRecordSchedule: (int) sessionHandle : (NSString*) jsonRecordSchedule : (command_Result) cmdResult;
- (void) getListMDNotification: (int) sessionHandle : (command_Result) cmdResult;
- (void) getZoneMDNotification: (int) sessionHandle : (command_Result) cmdResult;
- (void) getStatistic: (int) sessionHandle : (command_Result) cmdResult;
- (void) setLiveViewRecord: (int) sessionHandle : (int) action : (command_Result) cmdResult;
- (void) changeStorageModeRecordQuality: (int) sessionHandle : (NSString*) jsonChangeStorageModeAndRecordQuality : (command_Result) cmdResult; // ResultCb_s callback
- (void) setOnOffHumanDetect: (int) sessionHandle : (NSString*) msg : (command_Result) cmdResult; // ResultCb callback
- (void) setDefaultPTZ: (int) sessionHandle : (NSString*) msg : (command_Result) cmdResult; // ResultCb callback
- (void) getRssi: (int) sessionHandle : (command_Result) cmdResult; // ResultCb callback
- (void) getWdr: (int) sessionHandle : (command_Result) cmdResult; // ResultCb callback
- (void) getWifiList: (int) sessionHandle : (command_Result) cmdResult; // ResultCb callback
- (void) setWdr: (int) sessionHandle : (int) enable : (command_Result) cmdResult; // ResultCb callback
- (void) setWifi: (int) sessionHandle : (NSString*) ssid : (NSString*) pass : (int) manual : (command_Result) cmdResult; // ResultCb callback
- (void) setOnOffMDNotify: (int) sessionHandle : (int) enable : (command_Result) cmdResult; // ResultCb callback
- (void) checkOnlineStatus: (int) instanceID : (NSString*) cameraUID : (command_Result) cmdResult;
- (void) onOffSmartTracking: (int) sessionHandle : (int) enable : (command_Result) cmdResult; // ResultCb callback
@end
NS_ASSUME_NONNULL_END

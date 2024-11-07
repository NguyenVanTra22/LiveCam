//
//  VNPTCamApi_v2.h
//  OneHome
//
//  Created by ThiemJason on 09/02/2023.
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
/** ResultCb callback trả về sessionHandle, mã lỗi */
typedef void(*_resultCb_Response)(int, int, int);
/** ResultCbi callback trả về sessionHandle, mã lỗi và thông in "int" kèm theo */
typedef void(*_resultCb_i_Response)(int, int, int, int);
/** ResultCbi // Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "int", "int", "int" kèm theo */
typedef void(*_resultCb_ii_Response)(int, int, int, int, int);
/** // Hàm callback tr? l?i sessionHandle, mã l?i và các thông in "int", "int", "int", "int", "char*", "char*" kèm theo */
typedef void(*_resultCb_iiiss_Response)(int, int, int, int, int, char*, char*, char*);
/** Hàm callback tr? l?i sessionHandle, mã l?i và thông in "char*" kèm theo */
typedef void(*_resultCb_s_Response)(int, int, int, char*);
/** Hàm callback tr? l?i sessionHandle, mã l?i và thông in long kèm theo */
typedef void(*_resultCb_llll_Response)(int, int, int, int64_t, int64_t, int64_t, int64_t);
/** Command response 0: Success Anything else: Faliure */
typedef void (^command_Result)(int);

@interface OHCamSDKApi_v2 : NSObject
//MARK: - sharedInstance
+ (instancetype)new __attribute__((unavailable("please initialize by use .share or .share()")));
- (instancetype)init __attribute__((unavailable("please initialize by use .share or .share()")));
+ (instancetype)sharedInstance;

@property (nonatomic,copy) resultBlock resultCallback;
@property (nonatomic,copy) audioResponse audioResponse;
@property (nonatomic,copy) videoResponse videoResponse;
@property (nonatomic,copy) mediaResponse mediaResponse;
@property (nonatomic,copy) notifyResponse notifyResponse;

//MARK: - Method
- (void) initApi: (NSString *) initString;
- (void) connectCamera: (int) instanceID : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult : (_resultCb_i_Response) response;
- (void) disconnectCamera: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_Response) response;
- (void) reconnectCamera: (int) sessionHandle : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult : (_resultCb_i_Response) response;
- (void) getVideoQuality: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response;
- (void) getDeviceInfo: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response;
- (void) getRecordVideoQuality: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response; // ResultCb_i callback
- (void) startRecvAudio: (int) sessionHandle : (bool) enable : (command_Result) cmdResult : (_resultCb_Response) response;
- (void) startRecvVideo: (int) sessionHandle : (bool) isReceive : (command_Result) cmdResult : (_resultCb_Response) response;
- (void) setPassword: (int) sessionHandle : (NSString*) oldPassword : (NSString*) newPassword : (command_Result) cmdResult : (_resultCb_Response) response;
- (void) startSendAudio: (int) sessionHandle : (bool) isOn : (command_Result) cmdResult : (_resultCb_Response) response;
- (void) sendAudio: (int) sessionHandle : (uint8_t*) buffer : (int) bufferLength : (int) codec : (command_Result) cmdResult : (_resultCb_Response) response;
- (void) setMediaCallback;
- (void) setVideoCallback;
- (void) setAudioCallback;
- (void) setNotifyCallback;
- (void) setVideoStorageMode: (int) sessionHandle : (int) mode : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setDeviceAlarmVolume: (int) sessionHandle : (bool) isOpen : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback; // ResultCb callback
- (void) setPHPServer: (int) sessionHandle : (NSString*) ipAddress : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setTimezone: (int) sessionHandle : (int) timeZone : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback // use ResultCb
- (void) getFLipping: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response; // ResultCb_i callback
- (void) setFLipping: (int) sessionHandle : (bool) isFlipped : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setRun: (int) sessionHandl : (int) left : (int) right : (int) up : (int) down : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setVideoQuality: (int) sessionHandle : (int) mode : (int) framerate : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) formatSdcard: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) getDeviceSpeakerVolume: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response; // ResultCb_i callback
- (void) getDeviceMicVolume: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response; // ResultCb_i callback
- (void) setDeviceSpeakerVolume: (int) sessionHandle : (int) capture_volume : (int) playback_volume : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setDeviceMixVolume: (int) sessionHandle : (int) status : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setOnOffMotionDetection: (int) sessionHandle : (bool) md : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setSensiMotionDetection: (int) sessionHandle : (int) sensi : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setNotiFreqMotionDetection: (int) sessionHandle : (int) noti_freq : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setSpeakerMotionDetection: (int) sessionHandle : (bool) speaker : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setZoneMotionDetection: (int) sessionHandle : (NSString*) jsonZone : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback callback
- (void) setScheduleMotionDetection: (int) sessionHandle : (NSString*) schedulesStruct : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setUrlServer: (int) sessionHandle : (NSString*) ntp_server : (NSString*) cloud_server : (NSString*) ota_server : (NSString*) event_server : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) startUpdateFirmware: (int) sessionHandle : (NSString*) url : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) playSDVideo: (int) sessionHandle : (NSString*) fileName : (long) seekTo : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) getAllVedioTime: (int) sessionHandle : (int) begin : (int) end : (int) type : (int) page : (command_Result) cmdResult : (_resultCb_s_Response) response; // ResultCb_s callback
- (void) onOffMic: (int) sessionHandle : (bool) enable : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) startStopPlayback: (int) sessionHandle : (bool) enable : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setVideoRecordType: (int) sessionHandle : (NSString*) jsonRecordType : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) setVideoRecordQuality: (int) sessionHandle : (NSString*) jsonRecordQuality : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) getVideoRecordType: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response; // ResultCb_s callback
- (void) getListRecordSchedule: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response; // ResultCb_s callback
- (void) updateListRecordSchedule: (int) sessionHandle : (NSString*) jsonRecordSchedule : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
- (void) getListMDNotification: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response; // ResultCb_s callback
- (void) getZoneMDNotification: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response; // ResultCb_s callback
- (void) getStatistic: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_llll_Response) response; // ResultCb_llll callback
- (void) setLiveViewRecord: (int) sessionHandle : (int) action : (command_Result) cmdResult : (_resultCb_i_Response) response; // ResultCb_i callback
- (void) changeStorageModeRecordQuality: (int) sessionHandle : (NSString*) jsonChangeStorageModeAndRecordQuality : (command_Result) cmdResult : (_resultCb_Response) response; // ResultCb callback
@end
NS_ASSUME_NONNULL_END

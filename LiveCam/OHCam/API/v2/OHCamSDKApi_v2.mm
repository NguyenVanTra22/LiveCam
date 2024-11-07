//
//  VNPTCamApi_v2.m
//  OneHome
//
//  Created by ThiemJason on 09/02/2023.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

#import "OHCamSDKApi_v2.h"

@implementation OHCamSDKApi_v2
//MARK: - sharedInstance
+ (instancetype)sharedInstance
{
    static OHCamSDKApi_v2 *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OHCamSDKApi_v2 alloc] init];
    });
    return sharedInstance;
}

//MARK: - SetCallback
/** Set record callback */
- (void) setMediaCallback {
    SDK_API_setMediaCallback([](int sessionID, int type, char * buffer, int bufferLength, int seq, int timeStamp) -> int {
        if (OHCamSDKApi_v2.sharedInstance.mediaResponse) {
            OHCamSDKApi_v2.sharedInstance.mediaResponse(sessionID, type, buffer, bufferLength, seq, timeStamp);
        }
        return 0;
    });
}

/** Set audio callback */
- (void) setAudioCallback {
    SDK_API_setAudioCallback([](int sessionID, int type, char * buffer, int bufferLength, int seq, int timeStamp) -> int {
        if (OHCamSDKApi_v2.sharedInstance.audioResponse) {
            OHCamSDKApi_v2.sharedInstance.audioResponse(sessionID, buffer, bufferLength, seq, timeStamp);
        }
        return 0;
    });
}

- (void) setVideoCallback {
    SDK_API_setVideoCallback([](int sessionID, int type, AVFrame * avFrame, int bufferLength, int seq, int timeStamp) -> int {
        if (OHCamSDKApi_v2.sharedInstance.videoResponse) {
            OHCamSDKApi_v2.sharedInstance.videoResponse(sessionID, avFrame, bufferLength, seq, timeStamp);
        }
        return 0;
    });
}

- (void) setNotifyCallback {
    SDK_Notify_setNotifyCallback([](int sessionID, int commandID, int errorCode, int extraInt) -> int {
        if (OHCamSDKApi_v2.sharedInstance.notifyResponse) {
            OHCamSDKApi_v2.sharedInstance.notifyResponse(sessionID, commandID, errorCode, extraInt);
        }
        return 0;
    });
}

- (void) sendAudio: (int) sessionHandle : (uint8_t*) buffer : (int) bufferLength : (int) codec : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_sendAudio(sessionHandle, buffer, bufferLength, codec);
    cmdResult(result);
}

//MARK: - Method
/** Init API base */
- (void) initApi: (NSString *) initString {
    char *_initString = (char*)[initString UTF8String];
    SDK_API_init(_initString);
}

/** Connect camera */
- (void) connectCamera: (int) instanceID : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult : (_resultCb_i_Response) response {
    char *_cameraUID = (char*)[cameraUID UTF8String];
    char *_cameraPassword = (char*)[password UTF8String];
    char _bLanSearch = [bLanSearch  isEqual: @"0x7A"] ? 0x7A : 0;
    int result = SDK_API_connect(instanceID, _cameraUID, _cameraPassword, _bLanSearch, response);
    cmdResult(result);
}

/** Disconnect Camera */
- (void) disconnectCamera: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_disconnect(sessionHandle, response);
    cmdResult(result);
}

/** Reconnect camera */
- (void) reconnectCamera: (int) sessionHandle : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult : (_resultCb_i_Response) response {
    char *_cameraUID = (char*)[cameraUID UTF8String];
    char *_cameraPassword = (char*)[password UTF8String];
    char _bLanSearch = [bLanSearch  isEqual: @"0x7A"] ? 0x7A : 0;
    int result = SDK_API_reconnect(sessionHandle, _cameraUID, _cameraPassword, _bLanSearch, response);
    cmdResult(result);
}

/** Get camera video quality */
- (void) getVideoQuality: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response {
    int result = SDK_API_getVideoQuality(sessionHandle, response);
    cmdResult(result);
}

/** Get SD Card Info */
- (void) getDeviceInfo: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response {
    int result = SDK_API_getDeviceInfo(sessionHandle, response);
    cmdResult(result);
}

/** Start Recv Audio  */
- (void) startRecvAudio: (int) sessionHandle : (bool) enable : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_startRecvAudio(sessionHandle, enable, response);
    cmdResult(result);
}

/** Set Password */
- (void) setPassword: (int) sessionHandle : (NSString*) oldPassword : (NSString*) newPassword : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_oldPassword = (char*)[oldPassword UTF8String];
    char *_newPassword = (char*)[newPassword UTF8String];
    int result = SDK_API_setPassword(sessionHandle, _oldPassword, _newPassword, response);
    cmdResult(result);
}

/** Start Recv Video  */
- (void) startRecvVideo: (int) sessionHandle : (bool) isReceive : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_startRecvVideo(sessionHandle, isReceive, response);
    cmdResult(result);
}

/** Start Send Audio  */
- (void) startSendAudio: (int) sessionHandle : (bool) isOn : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_startSendAudio(sessionHandle, isOn, response);
    cmdResult(result);
}

/** setVideoStorageMode  */
- (void) setVideoStorageMode: (int) sessionHandle : (int) mode : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setVideoStorageMode(sessionHandle, mode, response);
    cmdResult(result);
}; // ResultCb callback

/** setDeviceAlarmVolume  */
- (void) setDeviceAlarmVolume: (int) sessionHandle : (bool) isOpen : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setDeviceAlarmVolume(sessionHandle, isOpen, response);
    cmdResult(result);
}; // ResultCb callback

/** setPHPServer  */
- (void) setPHPServer: (int) sessionHandle : (NSString*) ipAddress : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_ipAddress = (char*)[ipAddress UTF8String];
    int result = SDK_API_setPHPServer(sessionHandle, _ipAddress, response);
    cmdResult(result);
}; // ResultCb callback

/** setTimezone */
- (void) setTimezone: (int) sessionHandle : (int) timeZone : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setTimezone(sessionHandle, timeZone, response);
    cmdResult(result);
}; // use ResultCb

/** getFLipping */
- (void) getFLipping: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response {
    int result = SDK_API_getFLipping(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_i callback

/** setFLipping */
- (void) setFLipping: (int) sessionHandle : (bool) isFlipped : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setFLipping(sessionHandle, isFlipped, response);
    cmdResult(result);
}; // ResultCb

/** Set run */
- (void) setRun: (int) sessionHandl : (int) left : (int) right : (int) up : (int) down : (command_Result) cmdResult : (_resultCb_Response) response {
    //int result = SDK_API_setRun(sessionHandl, left, right, up, down, response);
    //cmdResult(result);
};// ResultCb callback

/** setVideoQuality */
- (void) setVideoQuality: (int) sessionHandle : (int) mode : (int) framerate : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setVideoQuality(sessionHandle, mode, framerate, response);
    cmdResult(result);
};// ResultCb callback

/** Format SDCard */
- (void) formatSdcard: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_formatSdcard(sessionHandle, response);
    cmdResult(result);
}; // ResultCb callback

/** getRecordVideoQuality */
- (void) getRecordVideoQuality: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response {
    int result = SDK_API_getRecordVideoQuality(sessionHandle, response);
    cmdResult(result);
} // ResultCb_i callback

/** getDeviceSpeakerVolume */
- (void) getDeviceSpeakerVolume: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response {
    int result = SDK_API_getDeviceSpeakerVolume(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_i callback

/** getDeviceMicVolume */
- (void) getDeviceMicVolume: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_i_Response) response {
    int result = SDK_API_getDeviceMicVolume(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_i callback

/** setDeviceSpeakerVolume */
- (void) setDeviceSpeakerVolume: (int) sessionHandle : (int) capture_volume : (int) playback_volume : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setDeviceSpeakerVolume(sessionHandle, capture_volume, playback_volume, response);
    cmdResult(result);
}; // ResultCb callback

/** setDeviceMixVolume  */
- (void) setDeviceMixVolume: (int) sessionHandle : (int) status : (command_Result) cmdResult {
    //    SDK_API_setDeviceMixVolume(sessionHandle, status, [](int a, int b, int c) {
    //        if (VNPTCamApi_v2.sharedInstance._resultCb_Response) {
    //            VNPTCamApi_v2.sharedInstance._resultCb_Response(a, b, c, SetDeviceMixVolume);
    //        }
    //    });
};    // ResultCb callback

/** setOnOffMotionDetection */
- (void) setOnOffMotionDetection: (int) sessionHandle : (bool) md : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setOnOffMotionDetection(sessionHandle, md, response);
    cmdResult(result);
};    // ResultCb callback

/** setSensiMotionDetection */
- (void) setSensiMotionDetection: (int) sessionHandle : (int) sensi : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setSensiMotionDetection(sessionHandle, sensi, response);
    cmdResult(result);
};    // ResultCb callback

/** setNotiFreqMotionDetection */
- (void) setNotiFreqMotionDetection: (int) sessionHandle : (int) noti_freq : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setNotiFreqMotionDetection(sessionHandle, noti_freq, response);
    cmdResult(result);
};    // ResultCb callback

/** setSpeakerMotionDetection */
- (void) setSpeakerMotionDetection: (int) sessionHandle : (bool) speaker : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_setSpeakerMotionDetection(sessionHandle, speaker, response);
    cmdResult(result);
};    // ResultCb callback

/** setZoneMotionDetection */
- (void) setZoneMotionDetection: (int) sessionHandle : (NSString*) jsonZone : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_jsonZone = (char*)[jsonZone UTF8String];
    int result = SDK_API_setZoneMotionDetection(sessionHandle, _jsonZone, response);
    cmdResult(result);
};    // ResultCb callback

/** setScheduleMotionDetection */
- (void) setScheduleMotionDetection: (int) sessionHandle : (NSString*) schedulesStruct : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_schedulesStruct = (char*)[schedulesStruct UTF8String];
    int result = SDK_API_setScheduleMotionDetection(sessionHandle, _schedulesStruct, response);
    cmdResult(result);
}; // ResultCb callback

/** setUrlUpgradeFirmware */
- (void) setUrlServer: (int) sessionHandle : (NSString*) ntp_server : (NSString*) cloud_server : (NSString*) ota_server : (NSString*) event_server : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_ntp_server = (char*)[ntp_server UTF8String];
    char *_cloud_server = (char*)[cloud_server UTF8String];
    char *_ota_server = (char*)[ota_server UTF8String];
    char *_event_server = (char*)[event_server UTF8String];
    int result = SDK_API_setUrlServer(sessionHandle, _ntp_server, _cloud_server, _ota_server, _event_server, response);
    cmdResult(result);
}; // ResultCb callback

/** start update firmware */
- (void) startUpdateFirmware: (int) sessionHandle : (NSString*) url : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_url = (char*)[url UTF8String];
    int result = SDK_API_updateFW(sessionHandle, _url, response);
    cmdResult(result);
}; // ResultCb callback

/** Play SD Video */
- (void) playSDVideo: (int) sessionHandle : (NSString*) fileName : (long) seekTo : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_fileName = (char*)[fileName UTF8String];
    int result = SDK_API_playSDVideo(sessionHandle, _fileName, seekTo, response);
    cmdResult(result);
}; // ResultCb callback  // tr?ng thái tr? l?i sau

/** getAllVedioTime */
- (void) getAllVedioTime: (int) sessionHandle : (int) begin : (int) end : (int) type : (int) page : (command_Result) cmdResult : (_resultCb_s_Response) response {
    int result = SDK_API_getAllVedioTime(sessionHandle, begin, end, type, page, response);
    cmdResult(result);
}; // ResultCb_s callback            // tr?ng thái tr? l?i sau

/** onOffMic */
- (void) onOffMic: (int) sessionHandle : (bool) enable : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_onOffMic(sessionHandle, enable, response);
    cmdResult(result);
} // ResultCb callback

- (void) startStopPlayback: (int) sessionHandle : (bool) enable : (command_Result) cmdResult : (_resultCb_Response) response {
    int result = SDK_API_startStopPlayback(sessionHandle, enable, response);
    cmdResult(result);
} // ResultCb callback

/** setVideoRecordType*/
- (void) setVideoRecordType: (int) sessionHandle : (NSString*) jsonRecordType : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_jsonRecordType = (char*)[jsonRecordType UTF8String];
    int result = SDK_API_setVideoRecordType(sessionHandle, _jsonRecordType, response);
    cmdResult(result);
} // ResultCb callback

/** get video record type */
- (void) getVideoRecordType: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response {
    int result = SDK_API_getVideoRecordType(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_s callback

/** getListRecordSchedule */
- (void) getListRecordSchedule: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response {
    int result = SDK_API_getListRecordSchedule(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_s callback

/** update list video record type */
- (void) updateListRecordSchedule: (int) sessionHandle : (NSString*) jsonRecordSchedule : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_recordSchedule = (char*)[jsonRecordSchedule UTF8String];
    int result = SDK_API_updateListRecordSchedule(sessionHandle, _recordSchedule, response);
    cmdResult(result);
} // ResultCb callback

/** get list md notification */
- (void) getListMDNotification: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response {
    int result = SDK_API_getListMDNotification(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_s callback

//int SDK_API_getZoneMDNotification (int sessionHandle, ResultCb_s resultCb);
- (void) getZoneMDNotification: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_s_Response) response {
    int result = SDK_API_getZoneMDNotification(sessionHandle, response);
    cmdResult(result);
}; // ResultCb_s callback

- (void) getStatistic: (int) sessionHandle : (command_Result) cmdResult : (_resultCb_llll_Response) response {
    int result = SDK_API_getStatistic(sessionHandle, response);
    cmdResult(result);
};

//int SDK_API_setVideoRecordQuality (int sessionHandle, ResultCb resultCb);
/** setVideoRecordQuality*/
- (void) setVideoRecordQuality: (int) sessionHandle : (NSString*) jsonQuality : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_jsonQuality = (char*)[jsonQuality UTF8String];
    int result = SDK_API_setVideoRecordQuality(sessionHandle, _jsonQuality, response);
    cmdResult(result);
} // ResultCb callback

/** Nhận data để record */
- (void) setLiveViewRecord: (int) sessionHandle : (int) action : (command_Result) cmdResult : (_resultCb_i_Response) response {
    int result = SDK_API_liveViewRecord(sessionHandle, action, response);
    cmdResult(result);
}

/** Thay đổi vị trí lưu trữ `Storage` */
- (void) changeStorageModeRecordQuality: (int) sessionHandle : (NSString*) jsonChangeStorageModeAndRecordQuality : (command_Result) cmdResult : (_resultCb_Response) response {
    char *_jsonChangeStorageModeAndRecordQuality = (char*)[jsonChangeStorageModeAndRecordQuality UTF8String];
    int result = SDK_API_changeStorageModeRecordQuality(sessionHandle, _jsonChangeStorageModeAndRecordQuality, response);
    cmdResult(result);
} // ResultCb_s callback

@end

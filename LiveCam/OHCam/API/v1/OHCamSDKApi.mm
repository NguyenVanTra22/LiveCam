//
//  VNPTCamApi.m
//  OneHome
//
//  Created by ThiemJason on 27/02/2022.
//  Copyright © 2022 VNPT Technology. All rights reserved.
//

#import "OHCamSDKApi.h"

@implementation OHCamSDKApi
//MARK: - sharedInstance
+ (instancetype)sharedInstance
{
    static OHCamSDKApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OHCamSDKApi alloc] init];
    });
    return sharedInstance;
}

//MARK: - SetCallback
/** Set record callback */
- (void) setMediaCallback {
    SDK_API_setMediaCallback([](int sessionID, int type, char * buffer, int bufferLength, int seq, int timeStamp) -> int {
        if (OHCamSDKApi.sharedInstance.mediaResponse) {
            OHCamSDKApi.sharedInstance.mediaResponse(sessionID, type, buffer, bufferLength, seq, timeStamp);
        }
        return 0;
    });
}

/** Set audio callback */
- (void) setAudioCallback {
    SDK_API_setAudioCallback([](int sessionID, int type, char * buffer, int bufferLength, int seq, int timeStamp) -> int {
        if (OHCamSDKApi.sharedInstance.audioResponse) {
            OHCamSDKApi.sharedInstance.audioResponse(sessionID, buffer, bufferLength, seq, timeStamp);
        }
        return 0;
    });
}

- (void) setVideoCallback {
    SDK_API_setVideoCallback([](int sessionID, int type, AVFrame * avFrame, int bufferLength, int seq, int timeStamp) -> int {
        if (OHCamSDKApi.sharedInstance.videoResponse) {
            OHCamSDKApi.sharedInstance.videoResponse(sessionID, avFrame, bufferLength, seq, timeStamp);
        }
        return 0;
    });
}

- (void) setNotifyCallback {
    SDK_Notify_setNotifyCallback([](int sessionID, int commandID, int errorCode, int extraInt) -> int {
        if (OHCamSDKApi.sharedInstance.notifyResponse) {
            OHCamSDKApi.sharedInstance.notifyResponse(sessionID, commandID, errorCode, extraInt);
        }
        return 0;
    });
}

- (void) setNotifyCallbackWithBody {
    SDK_Notify_setNotifyWithBodyCallback([](int sessionID, int commandID, int temp, int errorCode, char* body, int len) -> int {
        if (body == NULL) { return 0; };
        NSString* _body = @(body);
        if (OHCamSDKApi.sharedInstance.notifyBodyResponse) {
            OHCamSDKApi.sharedInstance.notifyBodyResponse(sessionID, commandID, temp, errorCode, _body, len);
        }
        return 0;
    });
}

- (void) sendAudio: (int) sessionHandle : (uint8_t*) buffer : (int) bufferLength : (int) codec : (command_Result) cmdResult {
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
- (void) connectCamera: (int) instanceID : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult {
    char *_cameraUID = (char*)[cameraUID UTF8String];
    char *_cameraPassword = (char*)[password UTF8String];
    char _bLanSearch = [bLanSearch  isEqual: @"0x7E"] ? 0x7E : 0;
    int result = SDK_API_connect(instanceID, _cameraUID, _cameraPassword, _bLanSearch, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}

/** Disconnect Camera */
- (void) disconnectCamera: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_disconnect(sessionHandle, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

/** Reconnect camera */
- (void) reconnectCamera: (int) sessionHandle : (NSString*) cameraUID : (NSString*) password : (NSString*) bLanSearch : (command_Result) cmdResult {
    char *_cameraUID = (char*)[cameraUID UTF8String];
    char *_cameraPassword = (char*)[password UTF8String];
    char _bLanSearch = [bLanSearch  isEqual: @"0x7E"] ? 0x7E : 0;
    int result = SDK_API_reconnect(sessionHandle, _cameraUID, _cameraPassword, _bLanSearch, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}

/** Get camera video quality */
- (void) getVideoQuality: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getVideoQuality(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}

/** Get SD Card Info */
- (void) getDeviceInfo: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getDeviceInfo(sessionHandle, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* deviceInfo = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, deviceInfo);
        }
    });
    cmdResult(result);
}

/** Start Recv Audio  */
- (void) startRecvAudio: (int) sessionHandle : (bool) enable : (command_Result) cmdResult {
    int result = SDK_API_startRecvAudio(sessionHandle, enable, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

/** Set Password */
- (void) setPassword: (int) sessionHandle : (NSString*) oldPassword : (NSString*) newPassword : (command_Result) cmdResult {
    char *_oldPassword = (char*)[oldPassword UTF8String];
    char *_newPassword = (char*)[newPassword UTF8String];
    int result = SDK_API_setPassword(sessionHandle, _oldPassword, _newPassword, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

/** Start Recv Video  */
- (void) startRecvVideo: (int) sessionHandle : (bool) isReceive : (command_Result) cmdResult {
    int result = SDK_API_startRecvVideo(sessionHandle, isReceive, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

/** Start Send Audio  */
- (void) startSendAudio: (int) sessionHandle : (bool) isOn : (command_Result) cmdResult {
    int result = SDK_API_startSendAudio(sessionHandle, isOn, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

/** setVideoStorageMode  */
- (void) setVideoStorageMode: (int) sessionHandle : (int) mode : (command_Result) cmdResult {
    int result = SDK_API_setVideoStorageMode(sessionHandle, mode, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** setDeviceAlarmVolume  */
- (void) setDeviceAlarmVolume: (int) sessionHandle : (bool) isOpen : (command_Result) cmdResult {
    int result = SDK_API_setDeviceAlarmVolume(sessionHandle, isOpen, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** setPHPServer  */
- (void) setPHPServer: (int) sessionHandle : (NSString*) ipAddress : (command_Result) cmdResult {
    char *_ipAddress = (char*)[ipAddress UTF8String];
    int result = SDK_API_setPHPServer(sessionHandle, _ipAddress, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** setTimezone */
- (void) setTimezone: (int) sessionHandle : (int) timeZone : (command_Result) cmdResult {
    int result = SDK_API_setTimezone(sessionHandle, timeZone, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // use ResultCb

/** getFLipping */
- (void) getFLipping: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getFLipping(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}; // ResultCb_i callback

/** setFLipping */
- (void) setFLipping: (int) sessionHandle : (bool) isFlipped : (command_Result) cmdResult {
    int result = SDK_API_setFLipping(sessionHandle, isFlipped, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb

/** Set run */
- (void) setRun: (int) sessionHandl : (int) left : (int) right : (int) up : (int) down : (command_Result) cmdResult {
    int result = SDK_API_setRun(sessionHandl, left, right, up, down, [](int a, int b, int c, char* d) {
        NSString* response;
        if (d == NULL) {
            response = @("");
        } else {
            response = @(d);
        };
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, response);
        }
    });
    cmdResult(result);
};// ResultCb callback

/** setVideoQuality */
- (void) setVideoQuality: (int) sessionHandle : (int) mode : (int) framerate : (command_Result) cmdResult {
    int result = SDK_API_setVideoQuality(sessionHandle, mode, framerate, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
};// ResultCb callback

/** Format SDCard */
- (void) formatSdcard: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_formatSdcard(sessionHandle, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** getRecordVideoQuality */
- (void) getRecordVideoQuality: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getRecordVideoQuality(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
} // ResultCb_i callback

/** getDeviceSpeakerVolume */
- (void) getDeviceSpeakerVolume: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getDeviceSpeakerVolume(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}; // ResultCb_i callback

/** getDeviceMicVolume */
- (void) getDeviceMicVolume: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getDeviceMicVolume(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}; // ResultCb_i callback

/** setDeviceSpeakerVolume */
- (void) setDeviceSpeakerVolume: (int) sessionHandle : (int) capture_volume : (int) playback_volume : (command_Result) cmdResult {
    int result = SDK_API_setDeviceSpeakerVolume(sessionHandle, capture_volume, playback_volume, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** setDeviceMixVolume  */
- (void) setDeviceMixVolume: (int) sessionHandle : (int) status : (command_Result) cmdResult {
    //    SDK_API_setDeviceMixVolume(sessionHandle, status, [](int a, int b, int c) {
    //        if (VNPTCamApi.sharedInstance.resultCb_Response) {
    //            VNPTCamApi.sharedInstance.resultCb_Response(a, b, c, SetDeviceMixVolume);
    //        }
    //    });
};    // ResultCb callback

/** setOnOffMotionDetection */
- (void) setOnOffMotionDetection: (int) sessionHandle : (bool) md : (command_Result) cmdResult {
    int result = SDK_API_setOnOffMotionDetection(sessionHandle, md, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
};    // ResultCb callback

/** setSensiMotionDetection */
- (void) setSensiMotionDetection: (int) sessionHandle : (int) sensi : (command_Result) cmdResult {
    int result = SDK_API_setSensiMotionDetection(sessionHandle, sensi, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
};    // ResultCb callback

/** setNotiFreqMotionDetection */
- (void) setNotiFreqMotionDetection: (int) sessionHandle : (int) noti_freq : (command_Result) cmdResult {
    int result = SDK_API_setNotiFreqMotionDetection(sessionHandle, noti_freq, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
};    // ResultCb callback

/** setSpeakerMotionDetection */
- (void) setSpeakerMotionDetection: (int) sessionHandle : (bool) speaker : (command_Result) cmdResult {
    int result = SDK_API_setSpeakerMotionDetection(sessionHandle, speaker, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
};    // ResultCb callback

/** setZoneMotionDetection */
- (void) setZoneMotionDetection: (int) sessionHandle : (NSString*) jsonZone : (command_Result) cmdResult {
    char *_jsonZone = (char*)[jsonZone UTF8String];
    int result = SDK_API_setZoneMotionDetection(sessionHandle, _jsonZone, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
};    // ResultCb callback

/** setScheduleMotionDetection */
- (void) setScheduleMotionDetection: (int) sessionHandle : (NSString*) schedulesStruct : (command_Result) cmdResult {
    char *_schedulesStruct = (char*)[schedulesStruct UTF8String];
    int result = SDK_API_setScheduleMotionDetection(sessionHandle, _schedulesStruct, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** setUrlUpgradeFirmware */
- (void) setUrlServer: (int) sessionHandle : (NSString*) ntp_server : (NSString*) cloud_server : (NSString*) ota_server : (NSString*) event_server : (command_Result) cmdResult {
    char *_ntp_server = (char*)[ntp_server UTF8String];
    char *_cloud_server = (char*)[cloud_server UTF8String];
    char *_ota_server = (char*)[ota_server UTF8String];
    char *_event_server = (char*)[event_server UTF8String];
    int result = SDK_API_setUrlServer(sessionHandle, _ntp_server, _cloud_server, _ota_server, _event_server, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** start update firmware */
- (void) startUpdateFirmware: (int) sessionHandle : (NSString*) url: (command_Result) cmdResult {
    char *_url = (char*)[url UTF8String];
    int result = SDK_API_updateFW(sessionHandle, _url, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

/** Play SD Video */
- (void) playSDVideo: (int) sessionHandle : (NSString*) fileName : (long) seekTo : (command_Result) cmdResult {
    char *_fileName = (char*)[fileName UTF8String];
    int result = SDK_API_playSDVideo(sessionHandle, _fileName, seekTo, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback  // tr?ng thái tr? l?i sau

/** getAllVedioTime */
- (void) getAllVedioTime: (int) sessionHandle : (int) begin : (int) end : (int) type : (int) page : (command_Result) cmdResult {
    int result = SDK_API_getAllVedioTime(sessionHandle, begin, end, type, page, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* videoString = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, videoString);
        }
    });
    cmdResult(result);
}; // ResultCb_s callback            // tr?ng thái tr? l?i sau

/** onOffMic */
- (void) onOffMic: (int) sessionHandle : (bool) enable : (command_Result) cmdResult {
    int result = SDK_API_onOffMic(sessionHandle, enable, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

- (void) startStopPlayback: (int) sessionHandle : (bool) enable : (command_Result) cmdResult {
    int result = SDK_API_startStopPlayback(sessionHandle, enable, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

/** setVideoRecordType*/
- (void) setVideoRecordType: (int) sessionHandle : (NSString*) jsonRecordType : (command_Result) cmdResult {
    char *_jsonRecordType = (char*)[jsonRecordType UTF8String];
    int result = SDK_API_setVideoRecordType(sessionHandle, _jsonRecordType, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

/** get video record type */
- (void) getVideoRecordType: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getVideoRecordType(sessionHandle, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* listRecordType = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, listRecordType);
        }
    });
    cmdResult(result);
}; // ResultCb_s callback

/** getListRecordSchedule */
- (void) getListRecordSchedule: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getListRecordSchedule(sessionHandle, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* listRecordSchedule = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, listRecordSchedule);
        }
    });
    cmdResult(result);
}; // ResultCb_s callback

/** update list video record type */
- (void) updateListRecordSchedule: (int) sessionHandle : (NSString*) jsonRecordSchedule : (command_Result) cmdResult {
    char *_recordSchedule = (char*)[jsonRecordSchedule UTF8String];
    int result = SDK_API_updateListRecordSchedule(sessionHandle, _recordSchedule, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

/** get list md notification */
- (void) getListMDNotification: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getListMDNotification(sessionHandle, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* listMDNotification = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, listMDNotification);
        }
    });
    cmdResult(result);
}; // ResultCb_s callback

//int SDK_API_getZoneMDNotification (int sessionHandle, ResultCb_s resultCb);
- (void) getZoneMDNotification: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getZoneMDNotification(sessionHandle, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* zoneMDNotification = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, zoneMDNotification);
        }
    });
    cmdResult(result);
}; // ResultCb_s callback

- (void) getStatistic: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getStatistic(sessionHandle, [](int a, int b, int c, int64_t totalByte, int64_t totalPackage, int64_t totalBytePs, int64_t totalPackagePs) {
        if (OHCamSDKApi.sharedInstance.resultCb_llll_Response) {
            OHCamSDKApi.sharedInstance.resultCb_llll_Response(a, b, c, totalByte, totalPackage, totalBytePs, totalPackagePs);
        }
    });
    cmdResult(result);
};

//int SDK_API_setVideoRecordQuality (int sessionHandle, ResultCb resultCb);
/** setVideoRecordQuality*/
- (void) setVideoRecordQuality: (int) sessionHandle : (NSString*) jsonQuality : (command_Result) cmdResult {
    char *_jsonQuality = (char*)[jsonQuality UTF8String];
    int result = SDK_API_setVideoRecordQuality(sessionHandle, _jsonQuality, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

/** Nhận data để record */
- (void) setLiveViewRecord: (int) sessionHandle : (int) action : (command_Result) cmdResult {
    int result = SDK_API_liveViewRecord(sessionHandle, action, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
}

/** Thay đổi vị trí lưu trữ `Storage` */
- (void) changeStorageModeRecordQuality: (int) sessionHandle : (NSString*) jsonChangeStorageModeAndRecordQuality : (command_Result) cmdResult {
    char *_jsonChangeStorageModeAndRecordQuality = (char*)[jsonChangeStorageModeAndRecordQuality UTF8String];
    int result = SDK_API_changeStorageModeRecordQuality(sessionHandle, _jsonChangeStorageModeAndRecordQuality, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb_s callback

- (void) setOnOffHumanDetect: (int) sessionHandle : (NSString*) msg : (command_Result) cmdResult {
    char *_msg = (char*)[msg UTF8String];
    int result = SDK_API_onOffHumanDetect(sessionHandle, _msg, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

- (void) setDefaultPTZ: (int) sessionHandle : (NSString*) msg : (command_Result) cmdResult {
    char *_msg = (char*)[msg UTF8String];
    int result = SDK_API_resetPtz(sessionHandle, _msg, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}

- (void) getRssi: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getRssi(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
} // ResultCb callback

- (void) getWdr: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getWdr(sessionHandle, [](int a, int b, int c, int d) {
        if (OHCamSDKApi.sharedInstance.resultCb_i_Response) {
            OHCamSDKApi.sharedInstance.resultCb_i_Response(a, b, c, d);
        }
    });
    cmdResult(result);
} // ResultCb callback

- (void) getWifiList: (int) sessionHandle : (command_Result) cmdResult {
    int result = SDK_API_getWifiList(sessionHandle, [](int a, int b, int c, char* d) {
        if (d == NULL) { return; };
        NSString* listWifi = @(d);
        if (OHCamSDKApi.sharedInstance.resultCb_s_Response) {
            OHCamSDKApi.sharedInstance.resultCb_s_Response(a, b, c, listWifi);
        }
    });
    cmdResult(result);
} // ResultCb callback

- (void) setWdr: (int) sessionHandle : (int) enable : (command_Result) cmdResult {
    int result = SDK_API_setWdr(sessionHandle, enable, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

- (void) onOffSmartTracking: (int) sessionHandle : (int) enable : (command_Result) cmdResult {
    int result = SDK_API_onOffSmartTracking(sessionHandle, enable, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

- (void) setWifi: (int) sessionHandle : (NSString*) ssid : (NSString*) pass : (int) manual : (command_Result) cmdResult {
    char *_ssid = (char*)[ssid UTF8String];
    char *_pass = (char*)[pass UTF8String];
    int result = SDK_API_setWifi(sessionHandle, _ssid, _pass, manual, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
} // ResultCb callback

- (void) setOnOffMDNotify: (int) sessionHandle : (int) enable : (command_Result) cmdResult {
    int result = SDK_API_setOnOffMotionNotification(sessionHandle, enable, [](int a, int b, int c) {
        if (OHCamSDKApi.sharedInstance.resultCb_Response) {
            OHCamSDKApi.sharedInstance.resultCb_Response(a, b, c);
        }
    });
    cmdResult(result);
}; // ResultCb callback

- (void) checkOnlineStatus: (int) instanceID : (NSString*) cameraUID : (command_Result) cmdResult {
    char *_uid = (char*)[cameraUID UTF8String];
    int result = SDK_API_checkOnlineStatus(instanceID, _uid);
    cmdResult(result);
};
@end

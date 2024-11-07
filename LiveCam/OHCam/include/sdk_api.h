#ifndef SDK_API_H
#define SDK_API_H
#include <stdint.h>
#include <unistd.h>
#include <stdbool.h>
#include <string>
#include "SdkApiInterface.h"


//typedef int (*NotifMediaDataFp) (int , int, char*, int ) ;
//typedef int (*NotifCommandCallBackFp) (int , int, int ) ;

#ifdef __cplusplus
extern "C" {
#endif
uint32_t sdk_init(char* initString);
void sdk_connect(char* deviceId);
void sdk_disconnect(char* deviceId);
void sdk_setTimeZone(char* deviceId, int tz ); 
void sdk_setVideoCallback(NotifMediaDataFp fp ) ;
void sdk_setAudioCallback(NotifMediaDataFp fp ) ;
void sdk_setResultCallback(NotifCommandCallBackFp fp ) ;
void sdk_sendVideoAppLayer(int sessionID, char* buf, int len, int sequence, int timestamp) ;
void sdk_sendAudioAppLayer(int sessionID, char* buf, int len, int sequence, int timestamp) ;
void sdk_sendResultCommand( int sessionId, int commandId, int result ) ; 
int sdk_sendaudio (int sessionId, uint8_t* buf, int len );
void sdk_sendMediaToAppLayer(int sessionID, int type , char* buf, int len, int sequence, int timestamp); 
uint32_t sdk_getAllSesison(); 
#ifdef __cplusplus
}
#endif
#endif 

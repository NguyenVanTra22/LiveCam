//
//  OHEventTracking.swift
//  OneHome
//
//  Created by ThiemJason on 11/13/23.
//  Copyright © 2023 VNPT Technology. All rights reserved.
//

import Foundation
//import FirebaseAnalytics
//import SwiftyJSON

class OHEventTracking {
    private init(){}
    public static let shared = OHEventTracking()
    
    public func log(_ event: OHEventTracking.OHEvent) {
//        self.logFirebase(event)
//        self.logLocal(event)
    }
    
//    public func setUserProperty(userId: String?) {
//        Analytics.setUserID(userId)
//    }
}

extension OHEventTracking {
//    private func logFirebase(_ event: OHEventTracking.OHEvent) {
//        Analytics.logEvent(event.name, parameters: event.params)
//    }
    
//    private func logLocal(_ event: OHEventTracking.OHEvent) {
//        let params          = event.params ?? [:]
//        let paramsString    = JSON(params).rawString(.utf8) ?? ""
//        let message = LoggerService.shared.getEventTrackingPrefix(event: event.name, params: params.isEmpty ? "" : paramsString)
//        LoggerService.shared.setLog(msg: message)
//    }
}

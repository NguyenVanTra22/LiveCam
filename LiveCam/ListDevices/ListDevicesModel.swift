//
//  ListDevicesModel.swift
//  LiveCam
//
//  Created by Developer 1 on 05/11/2024.
//

import Foundation

struct CameraModel: Codable {
    let name: String
    let uid: String
    let password: String?
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case uid
        case password
        case avatar
    }
}

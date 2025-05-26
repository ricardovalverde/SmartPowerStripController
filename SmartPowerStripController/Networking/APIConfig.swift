//
//  APIConfig.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://openapi.tuyaus.com"
    static let signmethod = "HMAC-SHA256"
    static let defaultTimeout: TimeInterval = 30
}

enum Endpoints{
    static let getToken = "/v1.0/token?grant_type=1"
    static let getDevice = "/v1.0/users/\(Credentials.uid!)/devices"
    static let getDeviceFunctions = "/v1.0/devices/\(Credentials.deviceId!)/functions"
    static let postCommand = "/v1.0/devices/\(Credentials.deviceId!)/commands"
       
}


enum HttpMethods {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

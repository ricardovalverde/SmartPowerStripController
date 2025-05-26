//
//  Credentials.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//
import Foundation

struct Credentials {
    static let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String
    static let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String
    static let uid = Bundle.main.object(forInfoDictionaryKey: "UID") as? String
    static let deviceId = Bundle.main.object(forInfoDictionaryKey: "DEVICE_ID") as? String
}

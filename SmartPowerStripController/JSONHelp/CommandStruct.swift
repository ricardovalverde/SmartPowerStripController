//
//  CommandStruct.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 25/05/25.
//

import Foundation

struct Command: Codable {
    let code: String
    let value: Bool
}

struct CommandRequest: Codable {
    let commands: [Command]
}

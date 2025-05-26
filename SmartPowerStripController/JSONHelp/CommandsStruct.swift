//
//  TokenStruct.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//


struct SendCommandResponse: Decodable {
    let success: Bool
    let code: Int?
    let msg: String?
}

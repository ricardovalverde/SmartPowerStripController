//
//  TokenStruct.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//

struct TokenResponse: Decodable {
    let result: TokenResult
    let success: Bool
}

struct TokenResult: Decodable {
    let access_token: String
    let expire_time: Int
    let refresh_token: String
    let uid: String
}

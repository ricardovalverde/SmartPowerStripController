//
//  JSONDecoder.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//

import Foundation

func JSONDecoderTokenResponse(data: Data) throws -> TokenResponse {
    let decoder = JSONDecoder()

    return try decoder.decode(TokenResponse.self, from: data)

}

func JSONDecoderSendCommandResponse(data: Data) throws -> SendCommandResponse {
    let decoder = JSONDecoder()

    return try decoder.decode(SendCommandResponse.self, from: data)

}

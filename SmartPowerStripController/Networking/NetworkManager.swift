//
//  NetworkManager.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchToken() async throws -> Data {
        let request = try GetToken.buildGetToken()
        let (data, response) = try await URLSession.shared.data(for: request)
        try ResponseValidator.validate(response)
        return data
    }
    
    func sendCommandPowerOn() async throws -> Data {
        let request = try PowerManagement.powerON()
        let (data,response) = try await URLSession.shared.data(for: request)
        try ResponseValidator.validate(response)
        return data
    }
}

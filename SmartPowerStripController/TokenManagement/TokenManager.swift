//
//  TokenManager.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//

import Foundation

struct TokenData {
    let accessToken: String
    let refreshToken: String
    let expireTime: TimeInterval
    let createdAt: Date
}

final class TokenManager {
    static let shared = TokenManager()
    private var token: TokenData?

    // Retorna o token válido, ou nil se expirado
    var accessToken: String? {
        guard let token = token else { return nil }
        let now = Date()
        if now.timeIntervalSince(token.createdAt) < token.expireTime {
            return token.accessToken
        }
        return nil
    }

    var refreshToken: String? {
        return token?.refreshToken
    }

    func saveToken(response: TokenResponse) {
        let result = response.result
        token = TokenData(
            accessToken: result.access_token,
            refreshToken: result.refresh_token,
            expireTime: TimeInterval(result.expire_time),
            createdAt: Date()
        )
       // print("SaveToken", result)
    }

    func clear() {
        token = nil
    }
}

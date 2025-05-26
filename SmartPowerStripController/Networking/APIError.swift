//
//  APIError.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}

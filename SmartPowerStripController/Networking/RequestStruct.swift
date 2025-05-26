//
//  RequestStruct.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 25/05/25.
//

import Foundation

func requestStruct(
    httpMethod: String,
    url: URL,
    signature: SignatureData,
    body: Data? = nil
) -> URLRequest {

    var request = URLRequest(url: url)

    request.httpMethod = httpMethod
    request.setValue((Credentials.clientId ?? ""), forHTTPHeaderField: "client_id")
    request.setValue(APIConfig.signmethod, forHTTPHeaderField: "sign_method")
    request.setValue(signature.signature, forHTTPHeaderField: "sign")
    request.setValue(signature.timestamp, forHTTPHeaderField: "t")
    request.setValue(signature.nonce, forHTTPHeaderField: "nonce")
    

    if let token = signature.token {
        request.setValue(token, forHTTPHeaderField: "access_token")
    }

    if let body = body {
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    return request
}

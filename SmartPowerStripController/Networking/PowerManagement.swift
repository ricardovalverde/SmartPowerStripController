//
//  PowerManagement.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 25/05/25.
//

import Foundation

enum PowerManagement {

    private static func powerSwitch(isOn: Bool) throws -> URLRequest {
        let command = Command(code: "switch_1", value: isOn)
        let request = CommandRequest(commands: [command])

        guard let jsonData = try? JSONEncoder().encode(request) else {
            throw URLError(.badServerResponse)
        }

        guard let url = URL(string: APIConfig.baseURL + Endpoints.postCommand)
        else {
            throw URLError(.badURL)
        }

        guard let token = TokenManager.shared.accessToken else {
            throw URLError(.userAuthenticationRequired)
        }

        let generateSignatureRequest = GenerateSignatureRequest(
            token: token,
            httpMethod: HttpMethods.post,
            url: Endpoints.postCommand
        )

        let generatedSignature = generateSignatureWithToken(
            signatureStructureRequest: generateSignatureRequest,
            jsonData: jsonData
        )

        return requestStruct(
            httpMethod: HttpMethods.post,
            url: url,
            signature: generatedSignature,
            body: jsonData
        )
    }
    
    static func powerON() throws -> URLRequest {
        return try powerSwitch(isOn: true)
    }

    static func powerOFF() throws -> URLRequest {
        return try powerSwitch(isOn: false)
    }

}

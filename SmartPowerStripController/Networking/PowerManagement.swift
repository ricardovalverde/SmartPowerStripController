//
//  PowerManagement.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 25/05/25.
//

import Foundation

enum PowerManagement {

    static func powerON() throws -> URLRequest {

        let command = Command(code: "switch_1", value: true)
        let request = CommandRequest(commands: [command])

        let jsonData = try? JSONEncoder().encode(request)
   
        guard let url = URL(string: APIConfig.baseURL + Endpoints.postCommand)
        else {
            throw URLError(.badURL)
        }

        let generateSignatureRequest = GenerateSignatureRequest(
            token:TokenManager.shared.accessToken!,
            httpMethod: HttpMethods.post,
            url: Endpoints.postCommand
        )

        let generetedSignature = generateSignatureWithToken(
            signatureStructureRequest: generateSignatureRequest,
            jsonData: jsonData!
        )

        return requestStruct(
            httpMethod: HttpMethods.post,
            url: url,
            signature: generetedSignature,
            body: jsonData
        )

    }

}

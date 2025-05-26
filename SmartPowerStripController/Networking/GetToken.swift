//
//  GetToken.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//
import Foundation

enum GetToken {

    static func buildGetToken() throws -> URLRequest {

        guard let url = URL(string: APIConfig.baseURL + Endpoints.getToken)
        else {
            throw URLError(.badURL)
        }

        let generateSignatureRequest = GenerateSignatureRequest(
            token: nil,
            httpMethod: HttpMethods.get,
            url: Endpoints.getToken
        )

        let generetedSignature = generateSignatureWithoutToken(
            signatureStructureRequest: generateSignatureRequest
        )

        return requestStruct(
            httpMethod: HttpMethods.get,
            url: url,
            signature: generetedSignature
        )

    }

}

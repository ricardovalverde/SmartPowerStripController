//
//  GerenciarEstadoSmartPowerStrip.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 28/05/25.
//

import Foundation

func gerenciarEstadoSmartPowerStrip(ligar: Bool) async throws {
    do {
        let data = try await NetworkManager.shared.fetchToken()

        TokenManager.shared.saveToken(
            response: try JSONDecoderTokenResponse(data: data)
        )

        if ligar {
            let data = try await NetworkManager.shared.sendCommandPowerOn()
            Notificador.shared.enviar(titulo: "🔌 Ligado", mensagem: "Switch foi ligado automaticamente.")
            print("PowerOn", try JSONDecoderSendCommandResponse(data: data))
        } else {
            let data = try await NetworkManager.shared.sendCommandPowerOff()
            print("PowerOff", try JSONDecoderSendCommandResponse(data: data))
            Notificador.shared.enviar(titulo: "⚡️ Desligado", mensagem: "Switch foi desligado automaticamente.")
        }
    }
}

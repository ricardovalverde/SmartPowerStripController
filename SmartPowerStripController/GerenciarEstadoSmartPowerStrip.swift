//
//  GerenciarEstadoSmartPowerStrip.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 28/05/25.
//

import Foundation
func gerenciarEstadoSmartPowerStrip(power: Bool) async {
    do {
        let data = try await NetworkManager.shared.fetchToken()
        TokenManager.shared.saveToken(
            response: try JSONDecoderTokenResponse(data: data)
        )

        if power {
            let data = try await NetworkManager.shared.sendCommandPowerOn()
            await MainActor.run {
                Notificador.shared.enviar(titulo: "🪫 Ligado", mensagem: "Switch foi ligado automaticamente.")
            }
            print("PowerOn", try JSONDecoderSendCommandResponse(data: data))
        } else {
            let data = try await NetworkManager.shared.sendCommandPowerOff()
            await MainActor.run {
                Notificador.shared.enviar(titulo: "🔋 Desligado", mensagem: "Switch foi desligado automaticamente.")
            }
            print("PowerOff", try JSONDecoderSendCommandResponse(data: data))
        }
    } catch {
        print("❌ Erro em gerenciarEstadoSmartPowerStrip:", error)
    }
}

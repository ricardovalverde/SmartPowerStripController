//
//  Notificador.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 28/05/25.
//

import Foundation
import UserNotifications

class Notificador {
    static let shared = Notificador()

    private init() {
        // Solicita permissão uma vez na inicialização
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("❌ Erro ao solicitar permissão de notificação: \(error)")
            } else {
                print(granted ? "✅ Permissão de notificação concedida" : "⚠️ Permissão de notificação negada")
            }
        }
    }

    func enviar(titulo: String, mensagem: String) {
        let content = UNMutableNotificationContent()
        content.title = titulo
        content.body = mensagem
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // dispara imediatamente
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Erro ao enviar notificação: \(error)")
            }
        }
    }
}

//
//  ContentView.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 11/05/25.
//

import SwiftUI

struct ContentView: View {
    init() {
        Task {

            do {
                //TokenManager.shared.clear()

                let data = try await NetworkManager.shared.fetchToken()

                TokenManager.shared.saveToken(
                    response: try JSONDecoderTokenResponse(data: data)
                )

                let poweron = try await NetworkManager.shared
                    .sendCommandPowerOn()

                print(
                    "PowerOn",
                    try JSONDecoderSendCommandResponse(data: poweron)
                )

                print(
                    "Resposta: \(String(data: data, encoding: .utf8) ?? "Error")"
                )

            } catch {
                print(error)
            }
        }
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! Teste Swift")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

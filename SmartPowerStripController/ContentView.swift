//
//  ContentView.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 11/05/25.
//

import SwiftUI

struct ContentView: View {

    
   /* init() {
        Task {

            do {
                //TokenManager.shared.clear()

                let data = try await NetworkManager.shared.fetchToken()

                TokenManager.shared.saveToken(
                    response: try JSONDecoderTokenResponse(data: data)
                )
                try await NetworkManager.shared
                    .sendCommandPowerOn()
//                let poweron = try await NetworkManager.shared
//                    .sendCommandPowerOn()
//
//                print(
//                    "PowerOn",
//                    try JSONDecoderSendCommandResponse(data: poweron)
//                )
                
//                let poweroff = try await NetworkManager.shared
//                    .sendCommandPowerOff()
//                
//
//                print(
//                    "PowerOff",
//                    try JSONDecoderSendCommandResponse(data: poweroff)
//                )
                let battery = updateBatteryLevel()
                
                func checkBatteryStatus(_ level: Int) async throws{
                    switch level {
                    case 0..<20:
                        print("Bateria fraca")
                    case 30..<80:
                        let poweron = try await NetworkManager.shared
                            .sendCommandPowerOn()
                       
                       
                                       print(
                                           "PowerOff",
                                           try JSONDecoderSendCommandResponse(data: poweron)
                                       )
                    case 80...100:
                        print("Bateria cheia")
                    default:
                        print("Valor inválido")
                    }
                }
               try await checkBatteryStatus(battery!)


            } catch {
                print(error)
            }
        }
    }*/
    
//    struct SliderExampleView: View {
//        @State private var selectedValue: Double = 50
//        @State private var isEditing = false
//        var body: some View {
//            VStack(spacing: 20) {
//                Text("Valor selecionado: \(Int(selectedValue))")
//                    .font(.title2)
//
//                Slider(
//                           value: $selectedValue,
//                           in: 0...100,
//                           onEditingChanged: { editing in
//                               isEditing = editing
//                           }
//                       )
//            }
//            .padding()
//        }
//    }

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

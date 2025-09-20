//
//  BatteryMonitor.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 27/05/25.
//

import Foundation
import IOKit.ps

class BatteryMonitor: ObservableObject {
    private var timer: Timer?
    private var estadoAtualDoSwitch: Bool? = nil

    func startMonitoring(intervalMinutes: Double = 5.0) {
        timer = Timer.scheduledTimer(
            withTimeInterval: intervalMinutes * 60,
            repeats: true
        ) { [weak self] _ in
            self?.checkBatteryLevel()
        }
        RunLoop.main.add(timer!, forMode: .common)
        checkBatteryLevel()  // Checa imediatamente na inicialização
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func checkBatteryLevel() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
            let sources = IOPSCopyPowerSourcesList(snapshot)?
                .takeRetainedValue() as? [CFTypeRef],
            let source = sources.first,
            let description = IOPSGetPowerSourceDescription(snapshot, source)?
                .takeUnretainedValue() as? [String: Any],
            let currentCapacity = description[kIOPSCurrentCapacityKey as String]
                as? Int,
            let maxCapacity = description[kIOPSMaxCapacityKey as String] as? Int
        else {
            print("⚠️ Não foi possível obter informações da bateria.")
            return
        }

        let batteryLevel = Double(currentCapacity) / Double(maxCapacity) * 100
        print("🔋 Nível da bateria: \(Int(batteryLevel))%")

        Task {
            do {
                if batteryLevel <= 25 {
                    if estadoAtualDoSwitch != true {
                        print("🔋 Switch ligado devido ao nível de bateria baixo")
                        try await gerenciarEstadoSmartPowerStrip(ligar: true)
                        estadoAtualDoSwitch = true
                    }
                } else if batteryLevel >= 70 {
                    if estadoAtualDoSwitch != false {
                        print("🔋 Switch desligado devido ao nível de bateria alto")
                        try await gerenciarEstadoSmartPowerStrip(ligar: false)
                        estadoAtualDoSwitch = false
                    }
                }
            } catch {
                print("❌ Erro ao gerenciar switch: \(error)")
            }
        }
    }
}

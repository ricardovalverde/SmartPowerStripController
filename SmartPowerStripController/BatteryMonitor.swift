//
//  BatteryMonitor.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 27/05/25.
//

import Foundation
import IOKit.ps

import IOKit.ps

class BatteryMonitor: ObservableObject {
    private var runLoopSource: Unmanaged<CFRunLoopSource>?
    private var estadoAtualDoSwitch: Bool? = nil

    func startMonitoring() {
        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        if let source = IOPSNotificationCreateRunLoopSource({ context in
            let monitor = Unmanaged<BatteryMonitor>.fromOpaque(context!).takeUnretainedValue()
            monitor.checkBatteryLevel()
        }, context).takeRetainedValue() as CFRunLoopSource? {
            runLoopSource = Unmanaged.passRetained(source)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .defaultMode)
        }
        checkBatteryLevel() // Checa imediatamente
    }

    func stopMonitoring() {
        if let source = runLoopSource?.takeUnretainedValue() {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .defaultMode)
        }
        runLoopSource = nil
    }

    private func checkBatteryLevel() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?
                  .takeUnretainedValue() as? [String: Any],
              let currentCapacity = description[kIOPSCurrentCapacityKey as String] as? Int,
              let maxCapacity = description[kIOPSMaxCapacityKey as String] as? Int else {
            print("⚠️ Não foi possível obter informações da bateria.")
            return
        }

        let batteryLevel = Double(currentCapacity) / Double(maxCapacity) * 100
        print("🔋 Nível da bateria: \(Int(batteryLevel))%")

        Task {
            do {
                if batteryLevel <= 25 {
                    if estadoAtualDoSwitch != true {
                        print("🔋 Ligando switch (bateria baixa)")
                        try await gerenciarEstadoSmartPowerStrip(ligar: true)
                        estadoAtualDoSwitch = true
                    }
                } else if batteryLevel >= 70 {
                    if estadoAtualDoSwitch != false {
                        print("🔋 Desligando switch (bateria alta)")
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


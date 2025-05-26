//
//  Battery.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 16/05/25.
//

import SwiftUI
import Foundation
import IOKit.ps


struct BatteryMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            BatteryView()
        }
    }
}

struct BatteryView: View {
    @State private var batteryLevel = "Carregando..."
    @State private var isRotating = false

    var body: some View {
        VStack {
            Image(systemName: "battery.100")
                .font(.system(size: 50))
            Text(batteryLevel)
                .font(.title)
            
            ProgressView()
        }
        .frame(width: 200, height: 150)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                updateBatteryLevel()
            }
        }
    }
    
    func updateBatteryLevel() {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        for source in sources {
            if let info = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as? [String: Any] {
                if let capacity = info[kIOPSCurrentCapacityKey] as? Int {
                    DispatchQueue.main.async {
                        batteryLevel = "\(capacity)%"
                    }
                }
            }
        }
    }
}

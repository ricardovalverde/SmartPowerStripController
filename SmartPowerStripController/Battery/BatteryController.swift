//
//  BatteryController.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 25/05/25.
//
import Foundation
func updateBatteryLevel() -> Int? {
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

    for source in sources {
        if let info = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as? [String: Any],
           let capacity = info[kIOPSCurrentCapacityKey] as? Int {
            return capacity
        }
    }

    return nil // Caso não encontre nenhuma fonte de energia
}

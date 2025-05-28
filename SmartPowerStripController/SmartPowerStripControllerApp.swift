//
//  SmartPowerStripControllerApp.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 11/05/25.
//

import SwiftUI

@main
struct SmartPowerStripControllerApp: App {
    @StateObject private var batteryMonitor = BatteryMonitor()
      // Gerenciador da barra de menu
      @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

      var body: some Scene {
          Settings {} // Nenhuma janela principal
      }
}
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    var batteryMonitor = BatteryMonitor()

    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarController = MenuBarController()
        batteryMonitor.startMonitoring()
    }

    func applicationWillTerminate(_ notification: Notification) {
        batteryMonitor.stopMonitoring()
    }
}

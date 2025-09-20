//
//  MenuBarController.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 27/05/25.
//

import SwiftUI
import AppKit

class MenuBarController {
    private var statusItem: NSStatusItem!

    init() {
        setupMenuBar()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "bolt.circle.fill", accessibilityDescription: "Battery Monitor")
        }

        let menu = NSMenu()

        let quitItem = NSMenuItem(title: "Sair", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self // ⚡ Essencial para habilitar o item
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc func quit() {
        NSApp.terminate(nil)
    }
}

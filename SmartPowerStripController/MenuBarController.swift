//
//  MenuBarController.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 27/05/25.
//

import Cocoa
import SwiftUI
import UserNotifications

class MenuBarController {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!

    init() {
        setupMenuBar()
        requestNotificationPermission()
    }

    private var eventMonitor: Any?

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "bolt.circle.fill",
                                   accessibilityDescription: "Battery Monitor")
            button.action = #selector(togglePopover)
            button.target = self
        }

        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 280, height: 180)
        popover.contentViewController = NSHostingController(rootView: PopoverContentView())
    }

    @objc private func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                closePopover()
            } else {
                popover.show(relativeTo: button.bounds,
                             of: button,
                             preferredEdge: .minY)
                startEventMonitor()
            }
        }
    }

    private func startEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.closePopover()
        }
    }

    private func closePopover() {
        popover.performClose(nil)

        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }


    // Permissão para notificações
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Erro ao pedir permissão: \(error)")
            } else {
                print("Permissão concedida? \(granted)")
            }
        }
    }
}


///Botoes de acao menubar
struct PopoverContentView: View {
    var body: some View {
        
        
        
        VStack(spacing: 16) {
            Text("Monitor de Bateria")
                .font(.headline)
            
            HStack(spacing: 16) {
                Button(action: {
                    Task {
                        try await gerenciarEstadoSmartPowerStrip(power: true)
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "togglepower")
                            .font(.system(size: 35))
                            .foregroundStyle(Color.green.opacity(0.9))
                        Text("Ligar")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
                .buttonStyle(.plain)
                .symbolEffect(.wiggle.byLayer, options: .nonRepeating)
                
                
                
                Button(action: {
                    Task {
                        try await gerenciarEstadoSmartPowerStrip(ligar: false)
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "poweroff")
                            .font(.system(size: 35))
                            .foregroundStyle(Color.red.opacity(0.6))
                        Text("Desligar")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
                .buttonStyle(.plain)
                .symbolEffect(.bounce.up.byLayer, options: .nonRepeating)
                

                
                
                
                
                
            }
            
     

            
            

            
            
            
            
            Button(action: {
                sendNotification(title: "Bateria", body: "Sua bateria está em 80%")
            }) {
                Label("Ver Status", systemImage: "battery.100")
            }
            .buttonStyle(.borderedProminent)
            
           

            Button(action: {
                sendNotification(title: "Teste", body: "Seu app está funcionando na barra de menu!")
            }) {
                Label("Testar Notificação", systemImage: "bell.badge")
            }
            .buttonStyle(.bordered)

            Divider()

            Button(role: .destructive) {
                NSApp.terminate(nil)
            } label: {
                Label("Sair", systemImage: "power")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Função helper global para mandar notificações
private func sendNotification(title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                        content: content,
                                        trigger: nil)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Erro ao enviar notificação: \(error)")
        }
    }
}

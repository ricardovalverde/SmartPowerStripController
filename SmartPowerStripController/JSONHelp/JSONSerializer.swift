//
//  JSONSerializer.swift
//  SmartPowerStripController
//
//  Created by Ricardo Valverde on 17/05/25.
//
import Foundation

func JSONData() -> Data? {
    let body: [String: Any] = [
        "commands": [
            ["code": "switch_4", "value": true]
        ]
    ]

    return try? JSONSerialization.data(withJSONObject: body, options: [])
}



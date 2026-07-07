//
//  CooldownManager.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import Foundation

// Generic rule: "given a transmitter ID, has enough time passed?"
// Knows nothing about beacons or audio — just timestamps and durations.
class CooldownManager {
    private var lastTriggered: [String: Date] = [:]
    private let cooldownDuration: TimeInterval = 30 * 60 // 30 minutes

    func isAllowed(transmitterID: String) -> Bool {
        guard let last = lastTriggered[transmitterID] else { return true }
        return Date().timeIntervalSince(last) >= cooldownDuration
    }

    func recordTrigger(transmitterID: String) {
        lastTriggered[transmitterID] = Date()
    }
}

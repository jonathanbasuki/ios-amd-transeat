//
//  SnoozeManager.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 07/07/26.
//

import Foundation

class SnoozeManager {
    private var timers: [String: Timer] = [:]
    private let snoozeDuration: TimeInterval = 5 * 60 // 5 minutes

    func scheduleRetry(transmitterID: String, action: @escaping () -> Void) {
        cancel(transmitterID: transmitterID)
        timers[transmitterID] = Timer.scheduledTimer(withTimeInterval: snoozeDuration, repeats: false) { _ in
            action()
        }
    }

    func cancel(transmitterID: String) {
        timers[transmitterID]?.invalidate()
        timers[transmitterID] = nil
    }
}

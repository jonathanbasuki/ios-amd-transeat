//
//  WatchConnectivityManager.swift
//  Transeat
//
//  Add this file to BOTH the "Transeat Watch App" target and the
//  iOS app target (check both boxes in File Inspector > Target Membership).
//

import Foundation
import WatchConnectivity
import Combine

/// Thin wrapper around WCSession used to keep the Watch and iPhone
/// UI in sync. Runs identically on both platforms.
@MainActor
final class WatchConnectivityManager: NSObject, ObservableObject {

    static let shared = WatchConnectivityManager()

    /// Latest screen name received from the counterpart device.
    /// The owning ViewModel observes this to mirror state.
    @Published private(set) var lastReceivedContext: [String: Any] = [:]

    /// Increments every time new context arrives. `[String: Any]` isn't
    /// Equatable, so views/view models that want to use `.onChange` or a
    /// Combine `.sink` keyed off "did something new arrive" should watch
    /// this counter instead of `lastReceivedContext` directly.
    @Published private(set) var updateCounter: Int = 0

    private override init() {
        super.init()
        guard WCSession.isSupported() else {
            print("[WCM] WCSession NOT supported on this device")
            return
        }
        WCSession.default.delegate = self
        WCSession.default.activate()
        print("[WCM] activate() called")
    }

    /// Send the current screen/countdown state to the counterpart device.
    /// Uses `updateApplicationContext` so the latest state is delivered
    /// even if the other device isn't reachable right now.
    func syncContext(_ context: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("[WCM] syncContext skipped — session not activated (state: \(WCSession.default.activationState.rawValue))")
            return
        }
        do {
            try WCSession.default.updateApplicationContext(context)
            print("[WCM] context sent: \(context)")
        } catch {
            print("[WCM] syncContext FAILED: \(error)")
        }
    }

    /// Send a one-off, low-latency message (e.g. a button tap) when the
    /// counterpart is immediately reachable. Falls back silently if not.
    func sendMessage(_ message: [String: Any]) {
        guard WCSession.default.activationState == .activated,
              WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("[WCM] activation state: \(activationState.rawValue), error: \(String(describing: error))")
    }

    #if os(iOS)
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif

    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("[WCM] didReceiveApplicationContext: \(applicationContext)")
        Task { @MainActor in
            self.lastReceivedContext = applicationContext
            self.updateCounter += 1
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("[WCM] didReceiveMessage: \(message)")
        Task { @MainActor in
            self.lastReceivedContext = message
            self.updateCounter += 1
        }
    }
}

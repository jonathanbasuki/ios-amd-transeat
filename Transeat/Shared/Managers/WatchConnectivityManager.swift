import Foundation
import WatchConnectivity
import Combine

@MainActor
final class WatchConnectivityManager: NSObject, ObservableObject {

    static let shared = WatchConnectivityManager()

    @Published private(set) var lastReceivedContext: [String: Any] = [:]
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

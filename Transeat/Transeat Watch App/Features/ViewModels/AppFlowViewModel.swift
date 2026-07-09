//
//  AppFlowViewModel.swift
//  Transeat
//

import SwiftUI
import Combine

/// Owns the current screen + countdown state on the Watch side.
///
/// `.welcome` and `.locating` are no longer driven by a fixed timer —
/// they now purely reflect whatever the iPhone is doing in real life
/// (validating pregnancy data vs. actively scanning for the beacon), so
/// the Watch just waits for that signal over WatchConnectivity instead
/// of guessing with a countdown.
@MainActor
final class AppFlowViewModel: ObservableObject {

    @Published private(set) var currentScreen: AppScreen = .welcome
    @Published private(set) var countdown: CountdownState = CountdownState(remainingSeconds: 0)

    private var timerCancellable: AnyCancellable?
    private var connectivityCancellable: AnyCancellable?

    init() {
        observeIncomingState()
        enter(.welcome, broadcast: false) // don't broadcast on launch; iPhone is the source of truth
    }

    deinit {
        timerCancellable?.cancel()
        connectivityCancellable?.cancel()
    }

    // MARK: - Screen entry / transitions

    /// - Parameter broadcast: pass `false` when this transition was itself
    ///   caused by an incoming update from the iPhone, so we don't just
    ///   echo it straight back and cause a feedback loop.
    func enter(_ screen: AppScreen, broadcast: Bool = true) {
        print("[AppFlowViewModel] enter(\(screen), broadcast: \(broadcast)) — was \(currentScreen)")
        timerCancellable?.cancel()
        currentScreen = screen
        if broadcast {
            broadcastState()
        }

        switch screen {
        case .welcome, .locating:
            break // waits entirely on the iPhone's real state (validating / scanning)

        case .confirmSeat:
            break // waits for user: Yes -> changeTrain, Not Yet -> haventSeatedTimer

        case .changeTrain:
            break // waits for user: Yes -> seatConfirmedTimer, Last Train (No) -> enjoyTrip

        case .countdownSeated:
            startCountdown(seconds: 30 * 60)

        case .countdownNotSeated:
            startCountdown(seconds: 5 * 60)

        case .enjoyTrip:
            break
        }
    }

    // MARK: - Button-driven transitions

    /// "Trigger Detected!" screen — Yes / Not Yet
    func seatCheckConfirmed(hasSeat: Bool) {
        print("[AppFlowViewModel] user tapped '\(hasSeat ? "Yes" : "Not Yet")' on seatCheck")
        enter(hasSeat ? .changeTrain : .countdownNotSeated)
    }

    /// "Are you going to change train?" screen — Yes / Last Train
    func changeTrainAnswered(isChanging: Bool) {
        print("[AppFlowViewModel] user tapped '\(isChanging ? "Yes, changing train" : "Last Train")' on changeTrain")
        enter(isChanging ? .countdownSeated : .enjoyTrip)
    }

    // MARK: - Countdown helper

    private func startCountdown(seconds: Int) {
        countdown = CountdownState(remainingSeconds: seconds)
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.countdown.tick()
                self.broadcastState()
                if self.countdown.isFinished {
                    self.timerCancellable?.cancel()
                }
            }
    }

    // MARK: - WatchConnectivity sync

    private func broadcastState() {
        print("[AppFlowViewModel] broadcasting to iPhone: \(currentScreen)")
        WatchConnectivityManager.shared.syncContext([
            "screen": String(describing: currentScreen),
            "remainingSeconds": countdown.remainingSeconds
        ])
    }

    /// Listens for state broadcast by the iPhone app and mirrors it here
    /// (e.g. onboarding/validation in progress -> welcome, beacon scanning
    /// -> locating, a modal appearing -> the matching screen, or a tap on
    /// the phone's own modal buttons).
    private func observeIncomingState() {
        connectivityCancellable = WatchConnectivityManager.shared.$updateCounter
            .sink { [weak self] _ in
                guard let self else { return }
                let context = WatchConnectivityManager.shared.lastReceivedContext
                print("[AppFlowViewModel] received update from iPhone, raw context: \(context)")
                guard let raw = context["screen"] as? String else {
                    print("[AppFlowViewModel] context had no 'screen' key — ignoring")
                    return
                }
                guard let incoming = AppScreen(rawDescription: raw) else {
                    print("[AppFlowViewModel] '\(raw)' did not match any AppScreen case — ignoring")
                    return
                }
                guard incoming != self.currentScreen else {
                    print("[AppFlowViewModel] incoming '\(raw)' same as current screen — no-op")
                    return
                }
                self.enter(incoming, broadcast: false)
            }
    }
}

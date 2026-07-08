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

    /// "Trigger Detected!" screen
    func seatCheckConfirmed(hasSeat: Bool) {
        enter(hasSeat ? .changeTrain : .countdownNotSeated)
    }

    /// "Are you going to change train?" screen
    func changeTrainAnswered(isChanging: Bool) {
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
                guard let raw = context["screen"] as? String,
                      let incoming = AppScreen(rawDescription: raw) else { return }
                guard incoming != self.currentScreen else { return }
                self.enter(incoming, broadcast: false)
            }
    }
}

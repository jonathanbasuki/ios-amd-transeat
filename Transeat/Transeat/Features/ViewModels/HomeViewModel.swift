//
//  HomeViewModel.swift
//  transeatluv
//
//  Owns HomeView's beacon lifecycle and keeps the Watch app in sync.
//  The state machine / timing itself is owned by HomeView now (per the
//  latest rewrite) — this ViewModel reacts to state changes rather than
//  driving them, except for the button-action helper methods below.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var currentState: HomeState = .home
    @Published var isModalDismissed = false
    @Published var dragOffset: CGFloat = 0

    let beaconTransmitter = BeaconTransmitterManager()

    private var isApplyingRemoteState = false
    private var connectivityCancellable: AnyCancellable?

    init() {
        observeIncomingState()
    }

    // MARK: - Lifecycle entry points (called from HomeView)

    /// NOTE: this no longer starts its own testing-flow timers — HomeView
    /// owns that now. This only handles the non-UI side effects: starting
    /// the beacon and telling the Watch what's happening.
    func onAppear() {
        startBeaconIfNeeded()
        broadcastStateToWatch() // sync immediately: Watch should show "locating" right away
    }

    func onDisappear() {
        beaconTransmitter.stopAdvertising()
    }

    func onStateChanged(to newState: HomeState) {
        isModalDismissed = false
        dragOffset = 0
        handleBeaconLifecycle(for: newState)
        broadcastStateToWatch()
    }

    // MARK: - Modal interactions

    func dismissModal() {
        withAnimation(.spring()) {
            isModalDismissed = true
            dragOffset = 0
        }
    }

    func updateDrag(_ translationHeight: CGFloat) {
        dragOffset = max(0, translationHeight)
    }

    func endDrag(_ translationHeight: CGFloat) {
        if translationHeight > 80 {
            dismissModal()
        } else {
            withAnimation(.spring()) { dragOffset = 0 }
        }
    }

    // MARK: - Button-driven transitions
    // Always call these from HomeView's buttons (instead of setting
    // `viewModel.currentState` directly) so the beacon stops and the
    // action gets printed/broadcast correctly no matter which button
    // triggered the transition.

    /// User tapped "Sudah" on the "Sudah dapat kursi?" popup.
    func confirmSeated() {
        print("[HomeViewModel] user tapped 'Sudah' — stopping beacon advertising")
        beaconTransmitter.stopAdvertising()
        currentState = .changeTrain
    }

    /// User tapped "Belum" on the "Sudah dapat kursi?" popup.
    func triggerUnconfirmDelayFlow() {
        print("[HomeViewModel] user tapped 'Belum' — stopping beacon advertising")
        beaconTransmitter.stopAdvertising()

        withAnimation { currentState = .seatUnconfirmDelay }

        // After 5 seconds, route back to the "Sudah dapat kursi?" popup
        // (matches HomeView's own delay timing for this state).
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            withAnimation { self?.currentState = .askSeated }
        }
    }

    func confirmChangingTrain() {
        currentState = .seatConfirmDelay
    }

    func declineChangingTrain() {
        currentState = .endTrip
    }

    // MARK: - Beacon lifecycle (non-UI)

    private func startBeaconIfNeeded() {
        if currentState == .home {
            print("[HomeViewModel] .home appeared — auto-starting beacon advertising")
            beaconTransmitter.startAdvertising()
        }
    }

    /// Keeps advertising through the whole "searching / detected, waiting
    /// for confirmation" phase (.home, .beaconFound, .goToSeat, .askSeated)
    /// — it must NOT stop just because a popup appeared. It only stops via
    /// an explicit user action (confirmSeated() / triggerUnconfirmDelayFlow())
    /// or once the flow moves past that phase entirely.
    private func handleBeaconLifecycle(for state: HomeState) {
        switch state {
        case .home, .beaconFound, .goToSeat, .askSeated:
            guard !beaconTransmitter.isAdvertising else { return }
            print("[HomeViewModel] state -> \(state) — auto-starting beacon advertising")
            beaconTransmitter.startAdvertising()
        default:
            guard beaconTransmitter.isAdvertising else { return }
            print("[HomeViewModel] state -> \(state) — stopping beacon advertising")
            beaconTransmitter.stopAdvertising()
        }
    }

    // MARK: - Watch <-> iPhone sync

    private var wireScreenName: String {
        switch currentState {
        case .home, .beaconFound, .goToSeat, .beaconNotFound: return "locating"
        case .askSeated: return "seatCheck"
        case .changeTrain: return "changeTrain"
        case .seatConfirmDelay: return "seatConfirmedTimer"
        case .seatUnconfirmDelay: return "haventSeatedTimer"
        case .endTrip: return "enjoyTrip"
        }
    }

    private static func homeState(fromWireScreenName name: String) -> HomeState? {
        switch name {
        case "seatCheck": return .askSeated
        case "changeTrain": return .changeTrain
        case "seatConfirmedTimer": return .seatConfirmDelay
        case "haventSeatedTimer": return .seatUnconfirmDelay
        case "enjoyTrip": return .endTrip
        default: return nil
        }
    }

    private func broadcastStateToWatch() {
        guard !isApplyingRemoteState else { return }
        print("[HomeViewModel] broadcasting state to Watch: \(wireScreenName)")
        WatchConnectivityManager.shared.syncContext([
            "screen": wireScreenName,
            "remainingSeconds": 0
        ])
    }

    private func observeIncomingState() {
        connectivityCancellable = WatchConnectivityManager.shared.$updateCounter
            .sink { [weak self] _ in
                guard let self else { return }
                let context = WatchConnectivityManager.shared.lastReceivedContext
                guard let raw = context["screen"] as? String else { return }

                self.isApplyingRemoteState = true
                defer { self.isApplyingRemoteState = false }

                switch (raw, self.currentState) {
                case ("changeTrain", .askSeated):
                    print("[HomeViewModel] 'Sudah' confirmed from Watch")
                    self.confirmSeated()

                case ("haventSeatedTimer", .askSeated):
                    print("[HomeViewModel] 'Belum' confirmed from Watch")
                    self.triggerUnconfirmDelayFlow()

                case ("seatConfirmedTimer", .changeTrain):
                    print("[HomeViewModel] 'Iya, ganti kereta' confirmed from Watch")
                    self.confirmChangingTrain()

                case ("enjoyTrip", .changeTrain):
                    print("[HomeViewModel] 'Tidak, kereta terakhir' confirmed from Watch")
                    self.declineChangingTrain()

                default:
                    guard let mapped = Self.homeState(fromWireScreenName: raw),
                          mapped != self.currentState else { return }
                    print("[HomeViewModel] applying incoming state from Watch: \(raw)")
                    withAnimation { self.currentState = mapped }
                }
            }
    }
}

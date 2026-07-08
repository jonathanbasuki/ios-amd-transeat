//
//  HomeViewModel.swift
//  transeatluv
//
//  Owns HomeView's flow state, modal-dismiss state, the testing timers,
//  the beacon lifecycle, AND keeps the Watch app in sync — every state
//  change here is broadcast, and incoming state from the Watch (e.g. a
//  button tapped there) is mirrored back into `currentState`.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var currentState: HomeState = .home

    /// Whether the user has manually dismissed the modal for the
    /// *current* state. Reset back to false every time currentState
    /// changes, so a new modal (e.g. the next reminder) still shows up.
    @Published var isModalDismissed = false

    /// Drag offset used for the swipe-down-to-dismiss gesture on the card.
    @Published var dragOffset: CGFloat = 0

    let beaconTransmitter = BeaconTransmitterManager()

    /// Guards against echoing a Watch-originated update straight back to
    /// the Watch (feedback loop prevention).
    private var isApplyingRemoteState = false
    private var connectivityCancellable: AnyCancellable?

    init() {
        observeIncomingState()
    }

    // MARK: - Derived state

    /// Whether the active state is one that *can* show a modal.
    var isModalState: Bool {
        switch currentState {
        case .beaconDetected, .changeTrain, .seatConfirmDelay, .seatUnconfirmDelay:
            return true
        default:
            return false
        }
    }

    /// Whether the modal should actually be visible right now.
    var isModalVisible: Bool {
        isModalState && !isModalDismissed
    }

    // MARK: - Lifecycle entry points (called from HomeView)

    func onAppear() {
        startTestingFlow()
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

    func confirmSeated() {
        currentState = .changeTrain
    }

    /// Handles loop for "Belum" selection
    func triggerUnconfirmDelayFlow() {
        withAnimation { currentState = .seatUnconfirmDelay }

        // After 15 seconds, route back to Beacon Detected
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
            withAnimation { self?.currentState = .beaconDetected }
        }
    }

    func confirmChangingTrain() {
        currentState = .seatConfirmDelay
    }

    func declineChangingTrain() {
        currentState = .endTrip
    }

    // MARK: - Automated testing flow

    private func startTestingFlow() {
        // Step 1: Default is .home. Transition to .goToSeat after 5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            withAnimation { self?.currentState = .goToSeat }

            // Step 2: Transition from .goToSeat to .beaconDetected after 5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation { self?.currentState = .beaconDetected }
            }
        }
    }

    // MARK: - Beacon lifecycle (non-UI)

    private func startBeaconIfNeeded() {
        if currentState == .home {
            print("[HomeViewModel] .home appeared — auto-starting beacon advertising")
            beaconTransmitter.startAdvertising()
        }
    }

    private func handleBeaconLifecycle(for state: HomeState) {
        switch state {
        case .home:
            guard !beaconTransmitter.isAdvertising else { return }
            print("[HomeViewModel] state -> .home — auto-starting beacon advertising")
            beaconTransmitter.startAdvertising()
        default:
            guard beaconTransmitter.isAdvertising else { return }
            print("[HomeViewModel] state -> \(state) — stopping beacon advertising")
            beaconTransmitter.stopAdvertising()
        }
    }

    // MARK: - Watch <-> iPhone sync

    /// Maps this screen's local `HomeState` to the shared wire-format name
    /// used by both platforms over WatchConnectivity (mirrors the Watch
    /// app's `AppScreen` enum case names). `.home` and `.goToSeat` both
    /// mean "scanning for the beacon", so both map to "locating".
    private var wireScreenName: String {
        switch currentState {
        case .home, .goToSeat: return "locating"
        case .beaconDetected: return "seatCheck"
        case .changeTrain: return "changeTrain"
        case .seatConfirmDelay: return "seatConfirmedTimer"
        case .seatUnconfirmDelay: return "haventSeatedTimer"
        case .endTrip: return "enjoyTrip"
        }
    }

    /// Reverse mapping for state that *arrives* from the Watch. "welcome"
    /// and "locating" are intentionally not mapped back — the Watch has no
    /// buttons on those screens, so it never originates a transition away
    /// from them; only the iPhone drives entry into `.home`/`.goToSeat`.
    private static func homeState(fromWireScreenName name: String) -> HomeState? {
        switch name {
        case "seatCheck": return .beaconDetected
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
                guard let raw = context["screen"] as? String,
                      let mapped = Self.homeState(fromWireScreenName: raw),
                      mapped != self.currentState else { return }

                print("[HomeViewModel] applying incoming state from Watch: \(raw)")
                self.isApplyingRemoteState = true
                withAnimation { self.currentState = mapped }
                self.isApplyingRemoteState = false
            }
    }
}

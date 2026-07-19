import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var currentState: HomeState = .home
    @Published var isModalDismissed = false
    @Published var dragOffset: CGFloat = 0

    let beaconTransmitter = BeaconTransmitterManager()
    let confirmationTransmitter = ConfirmationTransmitterManager()

    private var isApplyingRemoteState = false
    private var connectivityCancellable: AnyCancellable?

    init() {
        observeIncomingState()
    }

    func onAppear() {
        startBeaconIfNeeded()
        broadcastStateToWatch()
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
    
    func confirmSeated() {
        print("[HomeViewModel] user tapped 'Sudah' — stopping beacon advertising (entering changeTrain flow)")
        beaconTransmitter.stopAdvertising()
        confirmationTransmitter.send(.confirmedYes)
        currentState = .changeTrain
    }

    func triggerUnconfirmDelayFlow() {
        print("[HomeViewModel] user tapped 'Belum' — beacon keeps advertising (not yet at changeTrain)")
        confirmationTransmitter.send(.confirmedNo)

        withAnimation { currentState = .seatNotConfirmed }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            withAnimation { self?.currentState = .askSeated }
        }
    }

    func confirmChangingTrain() {
        currentState = .seatConfirmed
    }

    func declineChangingTrain() {
        currentState = .enjoyTrip
    }

    private func startBeaconIfNeeded() {
        if currentState == .home {
            print("[HomeViewModel] .home appeared — auto-starting beacon advertising")
            beaconTransmitter.startAdvertising()
        }
    }

    /// Keeps advertising through every state that occurs BEFORE the
    /// changeTrain confirmation (.home, .beaconFound, .beaconNotFound,
    /// .goToSeat, .askSeated, .seatNotConfirmed) — the beacon should stay
    /// on for the entire "still trying to get/confirm a seat" phase,
    /// regardless of which popup happens to be showing.
    /// It only stops once the flow actually reaches .changeTrain (see
    /// confirmSeated()) or beyond (.seatConfirmed, .enjoyTrip).
    private func handleBeaconLifecycle(for state: HomeState) {
        switch state {
        case .home, .beaconFound, .beaconNotFound, .goToSeat, .askSeated, .seatNotConfirmed:
            guard !beaconTransmitter.isAdvertising else { return }
            print("[HomeViewModel] state -> \(state) — auto-starting beacon advertising")
            beaconTransmitter.startAdvertising()
        case .changeTrain, .seatConfirmed, .enjoyTrip:
            guard beaconTransmitter.isAdvertising else { return }
            print("[HomeViewModel] state -> \(state) — stopping beacon advertising")
            beaconTransmitter.stopAdvertising()
        }
    }
    
    private var wireScreenName: String {
        switch currentState {
            case .home: return "locating"
            case .beaconFound, .goToSeat: return "beaconFound"
            case .beaconNotFound: return "beaconNotFound"
            case .askSeated: return "askSeated"
            case .changeTrain: return "changeTrain"
            case .seatConfirmed: return "seatConfirmed"
            case .seatNotConfirmed: return "seatNotConfirmed"
            case .enjoyTrip: return "enjoyTrip"
        }
    }

    private static func homeState(fromWireScreenName name: String) -> HomeState? {
        switch name {
            case "askSeated": return .askSeated
            case "changeTrain": return .changeTrain
            case "seatConfirmed": return .seatConfirmed
            case "seatNotConfirmed": return .seatNotConfirmed
            case "enjoyTrip": return .enjoyTrip
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

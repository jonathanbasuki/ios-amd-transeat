import SwiftUI
import Combine

@MainActor
final class AppFlowViewModel: ObservableObject {

    @Published private(set) var currentScreen: AppScreen = .home
    @Published private(set) var countdown: CountdownState = CountdownState(remainingSeconds: 0)

    private var timerCancellable: AnyCancellable?
    private var connectivityCancellable: AnyCancellable?

    init() {
        observeIncomingState()
        enter(.home, broadcast: false)
    }

    deinit {
        timerCancellable?.cancel()
        connectivityCancellable?.cancel()
    }

    func enter(_ screen: AppScreen, broadcast: Bool = true) {
        print("[AppFlowViewModel] enter(\(screen), broadcast: \(broadcast)) — was \(currentScreen)")
        timerCancellable?.cancel()
        currentScreen = screen
        if broadcast {
            broadcastState()
        }

        switch screen {
            case .home, .locating:
                break
            
            case .beaconFound:
                break
                
            case .beaconNotFound:
                break
            
            case .askSeated:
                break

            case .changeTrain:
                break
                
            case .seatConfirmed:
                break
                
            case .seatNotConfirmed:
                break

            case .enjoyTrip:
                break
        }
    }

    func seatCheckConfirmed(hasSeat: Bool) {
        print("[AppFlowViewModel] user tapped '\(hasSeat ? "Yes" : "Not Yet")' on seatCheck")
        enter(hasSeat ? .changeTrain : .seatNotConfirmed)
    }

    func changeTrainAnswered(isChanging: Bool) {
        print("[AppFlowViewModel] user tapped '\(isChanging ? "Yes, changing train" : "Last Train")' on changeTrain")
        enter(isChanging ? .seatConfirmed : .enjoyTrip)
    }

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

    private func broadcastState() {
        print("[AppFlowViewModel] broadcasting to iPhone: \(currentScreen)")
        WatchConnectivityManager.shared.syncContext([
            "screen": String(describing: currentScreen),
            "remainingSeconds": countdown.remainingSeconds
        ])
    }

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

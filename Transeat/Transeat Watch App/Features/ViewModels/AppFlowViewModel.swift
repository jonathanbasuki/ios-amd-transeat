import SwiftUI
import Combine

@MainActor
final class AppFlowViewModel: ObservableObject {

    @Published private(set) var currentScreen: AppScreen = .welcome
    @Published private(set) var countdown: CountdownState = CountdownState(remainingSeconds: 0)

    private var autoAdvanceTask: Task<Void, Never>?
    private var timerCancellable: AnyCancellable?

    init() {
        enter(.welcome)
    }

    deinit {
        autoAdvanceTask?.cancel()
        timerCancellable?.cancel()
    }

    // MARK: - Screen entry / transitions

    func enter(_ screen: AppScreen) {
        autoAdvanceTask?.cancel()
        timerCancellable?.cancel()
        currentScreen = screen

        switch screen {
        case .welcome:
            autoAdvance(after: 10) { [weak self] in self?.enter(.locating) }

        case .locating:
            autoAdvance(after: 10) { [weak self] in self?.enter(.confirmSeat) }

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

    // MARK: - Auto-advance helper

    private func autoAdvance(after seconds: TimeInterval, action: @escaping () -> Void) {
        autoAdvanceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run { action() }
        }
        _ = self
    }

    // MARK: - Countdown helper

    private func startCountdown(seconds: Int) {
        countdown = CountdownState(remainingSeconds: seconds)
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.countdown.tick()
                if self.countdown.isFinished {
                    self.timerCancellable?.cancel()
                }
            }
    }
}

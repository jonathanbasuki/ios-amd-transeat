import SwiftUI
import Combine

@MainActor
final class PhoneMirrorViewModel: ObservableObject {
    @Published private(set) var mirroredScreen: AppScreen = .welcome
    @Published private(set) var remainingSeconds: Int = 0

    private var cancellable: AnyCancellable?

    init() {
        cancellable = WatchConnectivityManager.shared.$lastReceivedContext
            .sink { [weak self] context in
                guard let self else { return }
                if let raw = context["screen"] as? String {
                    self.mirroredScreen = Self.screen(from: raw)
                }
                if let seconds = context["remainingSeconds"] as? Int {
                    self.remainingSeconds = seconds
                }
            }
    }

    private static func screen(from raw: String) -> AppScreen {
        switch raw {
        case "welcome": return .welcome
        case "locating": return .locating
        case "seatCheck": return .confirmSeat
        case "changeTrain": return .changeTrain
        case "seatConfirmedTimer": return .countdownSeated
        case "haventSeatedTimer": return .countdownNotSeated
        case "enjoyTrip": return .enjoyTrip
        default: return .welcome
        }
    }
}

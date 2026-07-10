import SwiftUI
import Combine

@MainActor
final class PhoneMirrorViewModel: ObservableObject {
    @Published private(set) var mirroredScreen: AppScreen = .home
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
            case "home": return .home
            case "locating": return .locating
            case "beaconFound": return .beaconFound
            case "beaconNotFound": return .beaconNotFound
            case "askSeated": return .askSeated
            case "changeTrain": return .changeTrain
            case "seatConfirmed": return .seatConfirmed
            case "seatNotConfirmed": return .seatNotConfirmed
            case "enjoyTrip": return .enjoyTrip
            default: return .home
        }
    }
}

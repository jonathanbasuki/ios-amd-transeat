import Foundation

enum AppScreen: Equatable {
    case home
    case locating
    case beaconFound
    case beaconNotFound
    case askSeated
    case changeTrain
    case seatConfirmed
    case seatNotConfirmed
    case enjoyTrip
    
    init?(rawDescription: String) {
        switch rawDescription {
            case "home": self = .home
            case "locating": self = .locating
            case "beaconFound": self = .beaconFound
            case "beaconNotFound": self = .beaconNotFound
            case "askSeated": self = .askSeated
            case "changeTrain": self = .changeTrain
            case "seatConfirmed": self = .seatConfirmed
            case "seatNotConfirmed": self = .seatNotConfirmed
            case "enjoyTrip": self = .enjoyTrip
            default: return nil
        }
    }
}

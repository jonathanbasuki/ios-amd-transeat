//
//  AppScreen.swift
//  Transeat
//

import Foundation

/// Every screen reachable in the TranSeat flow.
enum AppScreen: Equatable {
    case welcome
    case locating
    case confirmSeat            // "Trigger Detected!" - Yes/Not Yet
    case changeTrain          // "Are you going to change train?" - Yes/Last Train
    case countdownSeated   // 30:00 countdown
    case countdownNotSeated    // 05:00 countdown
    case enjoyTrip

    /// Parses the string produced by `String(describing:)` on the Watch
    /// side, or the equivalent name sent from the iPhone side. This is
    /// the shared "wire format" both platforms agree on when syncing
    /// state over WatchConnectivity.
    init?(rawDescription: String) {
        switch rawDescription {
        case "welcome": self = .welcome
        case "locating": self = .locating
        case "seatCheck": self = .confirmSeat
        case "changeTrain": self = .changeTrain
        case "seatConfirmedTimer": self = .countdownSeated
        case "haventSeatedTimer": self = .countdownNotSeated
        case "enjoyTrip": self = .enjoyTrip
        default: return nil
        }
    }
}

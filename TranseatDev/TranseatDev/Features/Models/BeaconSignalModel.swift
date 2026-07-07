//
//  BeaconSignalModel.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 07/07/26.
//

import Foundation

// Identifies one specific beacon transmitter device.
struct BeaconSignal: Equatable {
    let uuid: String
    let major: Int
    let minor: Int

    // Combines the three IDs into one string — used as a dictionary key
    // in CooldownManager to track "have I seen THIS transmitter recently?"
    var transmitterID: String {
        "\(uuid)-\(major)-\(minor)"
    }
}

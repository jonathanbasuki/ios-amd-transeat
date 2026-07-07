//
//  BeaconManager.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import Foundation
import CoreLocation
import Combine

class BeaconManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isOn: Bool = false
    @Published var detectedBeacon: BeaconSignal?

    private let locationManager = CLLocationManager()
    private let beaconUUID = UUID(uuidString: "1384E384-07AE-46E9-95F8-4AD0B9AE029B")!
    private lazy var constraint = CLBeaconIdentityConstraint(uuid: beaconUUID)
    private lazy var beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "com.yourapp.beacon")

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func startRanging() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startRangingBeacons(satisfying: constraint)
        isOn = true
        print("Beacon ranging started")
    }

    func stopRanging() {
        locationManager.stopRangingBeacons(satisfying: constraint)
        isOn = false
        print("Beacon ranging stopped")
    }

    // Called repeatedly (roughly once a second) with every matching
    // beacon currently visible — even ones that are far away.
    func locationManager(_ manager: CLLocationManager,
                          didRange beacons: [CLBeacon],
                          satisfying constraint: CLBeaconIdentityConstraint) {
        // We only care about beacons close enough to be "real"
        // detections, not ones two rooms away. .unknown means the OS
        // couldn't get a confident reading yet — worth ignoring too.
        guard let nearest = beacons.first(where: {
            $0.proximity == .near || $0.proximity == .immediate
        }) else { return }

        detectedBeacon = BeaconSignal(
            uuid: nearest.uuid.uuidString,
            major: nearest.major.intValue,
            minor: nearest.minor.intValue
        )
    }
}

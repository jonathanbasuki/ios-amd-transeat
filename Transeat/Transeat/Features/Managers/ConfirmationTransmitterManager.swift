//
//  ConfirmationTransmitterManager.swift
//  Transeat
//
//  Created by Brandon Nathan Haliman on 09/07/26.
//
//  Runs its OWN CBPeripheralManager, deliberately separate from
//  BeaconTransmitterManager. That one advertises iBeacon proximity data
//  (an OS-generated advertisement format used for CoreLocation ranging);
//  this one runs an ordinary GATT peripheral so the Receiver app can
//  connect, subscribe, and get notified the instant Mama confirms.
//  Keeping them in separate CBPeripheralManager instances avoids the two
//  advertising formats fighting over the same startAdvertising(_:) call.
//

import Foundation
import CoreBluetooth
import Combine

class ConfirmationTransmitterManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    @Published private(set) var isReceiverSubscribed: Bool = false

    private var peripheralManager: CBPeripheralManager!
    private var confirmationCharacteristic: CBMutableCharacteristic!

    // MUST exactly match the UUIDs the Receiver app's CBCentralManager
    // scans for / subscribes to — replace with your real values.
    private let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    private let characteristicUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")

    // Holds a result if send() is called before Bluetooth finishes
    // powering on, so a fast double-tap right after launch isn't lost.
    private var pendingResult: ConfirmationResult?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    /// Call this from HomeViewModel.confirmSeated() / triggerUnconfirmDelayFlow().
    /// Safe to call before Bluetooth is ready — the result is queued and
    /// sent as soon as peripheralManagerDidUpdateState reports .poweredOn.
    func send(_ result: ConfirmationResult) {
        guard peripheralManager.state == .poweredOn else {
            print("[ConfirmationTransmitter] not powered on yet — queuing \(result)")
            pendingResult = result
            return
        }
        transmit(result)
    }

    private func transmit(_ result: ConfirmationResult) {
        let data = Data([result.wireByte])
        let delivered = peripheralManager.updateValue(
            data,
            for: confirmationCharacteristic,
            onSubscribedCentrals: nil
        )
        print("[ConfirmationTransmitter] sent \(result), delivered immediately: \(delivered)")
    }

    // MARK: - CBPeripheralManagerDelegate

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else {
            print("[ConfirmationTransmitter] state changed: \(peripheral.state.rawValue)")
            return
        }
        setupServiceIfNeeded()
        startAdvertising()

        if let queued = pendingResult {
            pendingResult = nil
            transmit(queued)
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager,
                           central: CBCentral,
                           didSubscribeTo characteristic: CBCharacteristic) {
        isReceiverSubscribed = true
        print("[ConfirmationTransmitter] Receiver subscribed")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager,
                           central: CBCentral,
                           didUnsubscribeFrom characteristic: CBCharacteristic) {
        isReceiverSubscribed = false
        print("[ConfirmationTransmitter] Receiver unsubscribed")
    }

    // MARK: - Setup

    private func setupServiceIfNeeded() {
        // Guard against re-adding the service every time this delegate
        // method fires (it can fire more than once, e.g. after a
        // Bluetooth toggle) — CBPeripheralManager doesn't dedupe for you.
        guard confirmationCharacteristic == nil else { return }

        confirmationCharacteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.notify, .read],
            value: nil, // must be nil for a notify-based characteristic
            permissions: [.readable]
        )

        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [confirmationCharacteristic]
        peripheralManager.add(service)
    }

    private func startAdvertising() {
        guard !peripheralManager.isAdvertising else { return }
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
        ])
    }
}

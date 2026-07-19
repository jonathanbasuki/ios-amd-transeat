//
//  AppViewModel.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import Foundation
import Combine

enum ScreenState {
    case camera
    case signalReceived
}

class AppViewModel: ObservableObject {
    @Published var screenState: ScreenState = .camera

    let cameraManager = CameraManager()
    let personDetector = PersonDetector()
    let beaconManager = BeaconManager()
    let audioManager = AudioPlayerManager()
    let cooldownManager = CooldownManager()
    let confirmationManager = ConfirmationManager()
    let snoozeManager = SnoozeManager()

    // Remembers which transmitter triggered the current popup, so that
    // when a Yes/No confirmation comes back (with no beacon info
    // attached), we know whose cooldown/snooze timer to touch.
    private var activeTransmitterID: String?

    private var cancellables = Set<AnyCancellable>()

    var isSeatAvailable: Bool {
        personDetector.detectedPersons.isEmpty
    }

    init() {
        cameraManager.onFrameCaptured = { [weak self] pixelBuffer in
            self?.personDetector.detect(in: pixelBuffer)
        }
        observeDetection()
        observeBeaconSignal()

        personDetector.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        beaconManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        confirmationManager.onConfirmationReceived = { [weak self] result in
            self?.handleConfirmation(result)
        }
    }

    func start() {
        cameraManager.start()
    }

    private func observeDetection() {
        personDetector.$detectedPersons
            .sink { [weak self] persons in
                guard let self else { return }
                if persons.isEmpty {
                    self.beaconManager.stopRanging()
                } else {
                    self.beaconManager.startRanging()
                }
            }
            .store(in: &cancellables)
    }

    private func observeBeaconSignal() {
        beaconManager.$detectedBeacon
            .compactMap { $0 }
            .sink { [weak self] signal in
                guard let self else { return }
                guard self.cooldownManager.isAllowed(transmitterID: signal.transmitterID) else {
                    print("Transmitter \(signal.transmitterID) is on cooldown — ignoring")
                    return
                }
                self.activeTransmitterID = signal.transmitterID
                self.cooldownManager.recordTrigger(transmitterID: signal.transmitterID)
                self.screenState = .signalReceived
                self.audioManager.playAlertSound()
            }
            .store(in: &cancellables)
    }

    private func handleConfirmation(_ result: ConfirmationResult) {
        guard let transmitterID = activeTransmitterID else { return }

        switch result {
        case .confirmedYes:
            audioManager.stop()
            // Already recorded on detection, but re-recording here means
            // the 30-min window starts from the moment of confirmation,
            // not from when the beacon was first seen — more accurate
            // if the user takes a while to respond.
            cooldownManager.recordTrigger(transmitterID: transmitterID)
            snoozeManager.cancel(transmitterID: transmitterID)
            screenState = .camera

        case .confirmedNo:
            // Audio deliberately keeps playing.
            screenState = .camera
            snoozeManager.scheduleRetry(transmitterID: transmitterID) { [weak self] in
                guard let self else { return }
                // Guard against a Yes sneaking in during the 5 minutes.
                if self.cooldownManager.isAllowed(transmitterID: transmitterID) {
                    self.screenState = .signalReceived
                    self.audioManager.playAlertSound()
                }
            }
        }
    }
}

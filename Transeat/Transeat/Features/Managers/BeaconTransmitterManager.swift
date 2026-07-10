import Foundation
import CoreLocation
import CoreBluetooth
import Combine

class BeaconTransmitterManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    @Published var isAdvertising: Bool = false

    // Intentionally NOT created in init() anymore. Instantiating a
    // CBPeripheralManager is what triggers iOS's Bluetooth permission
    // prompt — if we create it eagerly the moment this object exists
    // (e.g. as a stored property on a ViewModel that gets constructed
    // during a navigation push), the prompt can pop up mid-transition
    // and steal focus from whatever's on screen at that moment (like a
    // "data saved" confirmation). Creating it lazily means the prompt
    // only appears the first time `startAdvertising()` is actually
    // called — i.e. once HomeView has genuinely appeared.
    private var peripheralManager: CBPeripheralManager?

    private(set) var beaconUUID: UUID = UUID(uuidString: "1384E384-07AE-46E9-95F8-4AD0B9AE029B")!
    private(set) var major: CLBeaconMajorValue = 1
    private(set) var minor: CLBeaconMinorValue = 1

    private var pendingStartRequested = false

    func configure(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        guard !isAdvertising else {
            print("Cannot reconfigure while advertising — call stopAdvertising() first")
            return
        }
        self.beaconUUID = uuid
        self.major = major
        self.minor = minor
    }

    func startAdvertising() {
        let manager = peripheralManagerLazy()
        guard manager.state == .poweredOn else {
            print("Bluetooth not ready yet — will start once it is")
            pendingStartRequested = true
            return
        }
        beginAdvertising()
    }

    /// Creates the CBPeripheralManager on first use. This is the actual
    /// moment the system Bluetooth permission prompt appears.
    private func peripheralManagerLazy() -> CBPeripheralManager {
        if let existing = peripheralManager {
            return existing
        }
        print("[BeaconTransmitterManager] creating CBPeripheralManager — Bluetooth permission prompt should appear now")
        let manager = CBPeripheralManager(delegate: self, queue: nil)
        peripheralManager = manager
        return manager
    }

    private func beginAdvertising() {
        guard let peripheralManager else { return }
        let region = CLBeaconRegion(
            uuid: beaconUUID,
            major: major,
            minor: minor,
            identifier: "com.amd.transeat"
        )
        let peripheralData = region.peripheralData(withMeasuredPower: nil as NSNumber?)
        peripheralManager.startAdvertising(peripheralData as? [String: Any])
        isAdvertising = true
        print("Advertising started — uuid: \(beaconUUID), major: \(major), minor: \(minor)")
    }

    func stopAdvertising() {
        // No-op if we never even created the manager (e.g. permission was
        // never granted, or startAdvertising() was never called yet).
        guard let peripheralManager else { return }
        peripheralManager.stopAdvertising()
        isAdvertising = false
        print("Advertising stopped")
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            if pendingStartRequested {
                pendingStartRequested = false
                beginAdvertising()
            }
        default:
            print("Bluetooth state changed: \(peripheral.state.rawValue)")
        }
    }
}

import Foundation
import CoreLocation
import CoreBluetooth
import Combine

class BeaconTransmitterManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    @Published var isAdvertising: Bool = false

    private var peripheralManager: CBPeripheralManager!

    private(set) var beaconUUID: UUID = UUID(uuidString: "1384E384-07AE-46E9-95F8-4AD0B9AE029B")!
    private(set) var major: CLBeaconMajorValue = 1
    private(set) var minor: CLBeaconMinorValue = 1

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

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
        guard peripheralManager.state == .poweredOn else {
            print("Bluetooth not ready yet — will start once it is")
            pendingStartRequested = true
            return
        }
        beginAdvertising()
    }

    private func beginAdvertising() {
        let region = CLBeaconRegion(
            uuid: beaconUUID,
            major: major,
            minor: minor,
            identifier: "com.yourapp.beacon"
        )
        let peripheralData = region.peripheralData(withMeasuredPower: nil as NSNumber?)
        peripheralManager.startAdvertising(peripheralData as? [String: Any])
        isAdvertising = true
        print("Advertising started — uuid: \(beaconUUID), major: \(major), minor: \(minor)")
    }

    func stopAdvertising() {
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

    private var pendingStartRequested = false
}

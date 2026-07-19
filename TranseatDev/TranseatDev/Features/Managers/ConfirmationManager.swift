//
//  ConfirmationManager.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import Foundation
import Combine

enum ConfirmationResult {
    case confirmedYes
    case confirmedNo
}

class ConfirmationManager: ObservableObject {
    var onConfirmationReceived: ((ConfirmationResult) -> Void)?

    // Your CBPeripheralDelegate's didUpdateValueFor calls this once the
    // real Bluetooth path exists. Keeps BLE knowledge out of this class.
    func handleCharacteristicUpdate(_ data: Data) {
        guard let byte = data.first else { return }
        let result: ConfirmationResult = (byte == 0x01) ? .confirmedYes : .confirmedNo
        onConfirmationReceived?(result)
    }
}

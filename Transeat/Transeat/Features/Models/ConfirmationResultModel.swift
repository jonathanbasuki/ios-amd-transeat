//
//  ConfirmationResultModel.swift
//  Transeat
//
//  Created by Brandon Nathan Haliman on 09/07/26.
//

//  The two possible answers Mama can give on the "Sudah dapat kursi?"
//  popup. Sent to the Receiver app as a single byte over GATT notify so
//  the Receiver knows whether to kill its alarm (Yes) or keep it going
//  and retry later (No).
//
 
import Foundation
 
enum ConfirmationResult {
    case confirmedYes
    case confirmedNo
 
    /// Single-byte wire format — matches what the Receiver app's
    /// ConfirmationManager already expects (0x01 = yes, anything else = no).
    var wireByte: UInt8 {
        switch self {
        case .confirmedYes: return 0x01
        case .confirmedNo: return 0x00
        }
    }
}

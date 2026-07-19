import Foundation
 
enum ConfirmationResultState {
    case confirmedYes
    case confirmedNo
    
    var wireByte: UInt8 {
        switch self {
        case .confirmedYes: return 0x01
        case .confirmedNo: return 0x00
        }
    }
}

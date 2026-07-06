import Foundation

struct CountdownState {
    var remainingSeconds: Int
 
    var formatted: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
 
    var isFinished: Bool { remainingSeconds <= 0 }
 
    mutating func tick() {
        guard remainingSeconds > 0 else { return }
        remainingSeconds -= 1
    }
}
 

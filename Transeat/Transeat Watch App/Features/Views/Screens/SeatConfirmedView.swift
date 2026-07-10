import SwiftUI

struct SeatConfirmedView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-seated", isPulsing: false)
            
            ScreenTitleText(text: "Kursi terkonfirmasi!")
        }
    }
}

#Preview {
    SeatConfirmedView()
}

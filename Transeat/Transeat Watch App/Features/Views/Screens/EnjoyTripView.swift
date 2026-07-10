import SwiftUI

struct EnjoyTripView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-hai", isPulsing: false)
            
            ScreenTitleText(text: "Nikmati perjalanan, Mama!")
            ScreenBodyText(text: "Pakailah kami lagi pada perjalanan Anda berikutnya.")
        }
    }
}

#Preview {
    EnjoyTripView()
}

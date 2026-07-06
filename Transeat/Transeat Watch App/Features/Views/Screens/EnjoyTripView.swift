import SwiftUI

struct EnjoyTripView: View {
    var body: some View {
        WatchContainer {
            MascotView(isPulsing: false)
            
            ScreenTitleText(text: "Nikmati perjalananmu, Mama!")
            ScreenBodyText(text: "Gunakan kami lagi untuk perjalanan lainnya, ya!")
        }
    }
}

#Preview {
    EnjoyTripView()
}

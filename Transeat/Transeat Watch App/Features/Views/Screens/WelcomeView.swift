import SwiftUI

struct WelcomeView: View {
    var body: some View {
        WatchContainer {
            MascotView(isPulsing: false)
            
            ScreenTitleText(text: "Selamat datang,\nMama!")
            ScreenBodyText(text: "TranSeat siap menemani perjalanan Mama!")
        }
    }
}

#Preview {
    WelcomeView()
}

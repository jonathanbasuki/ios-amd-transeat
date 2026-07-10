import SwiftUI

struct WelcomeView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-hai", isPulsing: false)
            
            ScreenTitleText(text: "Yuk, Verifikasi Kehamilan!")
            ScreenBodyText(text: "Lengkapi data Mama untuk mulai menggunakan TranSeat!")
        }
    }
}

#Preview {
    WelcomeView()
}

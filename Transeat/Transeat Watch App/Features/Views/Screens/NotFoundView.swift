import SwiftUI

struct NotFoundView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-detected", isPulsing: false)
            
            ScreenTitleText(text: "Kursi penuh!\nMencari kursi lain...")
            ScreenBodyText(text: "Pastikan ponsel selalu dalam keadaan menyala!")
        }
    }
}

#Preview {
    NotFoundView()
}

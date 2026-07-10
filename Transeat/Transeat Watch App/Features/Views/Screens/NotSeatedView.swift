import SwiftUI

struct NotSeatedView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-notseated", isPulsing: false)
            
            ScreenTitleText(text: "Belum dapat tempat duduk?")
            ScreenBodyText(text: "Tunggu sebentar ya, kami akan mencarikan lagi!")
        }
    }
}

#Preview {
    NotSeatedView()
}

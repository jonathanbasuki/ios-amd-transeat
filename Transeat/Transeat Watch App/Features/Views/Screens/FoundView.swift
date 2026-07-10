import SwiftUI

struct FoundView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-detected", isPulsing: false)
            
            ScreenTitleText(text: "Kursi ditemukan!")
            ScreenBodyText(text: "Silahkan menuju ke gerbong 4!")
        }
    }
}

#Preview {
    FoundView()
}

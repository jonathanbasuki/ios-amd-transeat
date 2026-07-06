import SwiftUI

struct LocatingView: View {
    var body: some View {
        WatchContainer {
            MascotView(isPulsing: true)
            
            ScreenTitleText(text: "Kita sedang mencarimu Mama!")
            ScreenBodyText(text: "Pastikan ponsel Mama selalu dalam keadaan menyala, ya!")
        }
    }
}

#Preview {
    LocatingView()
}

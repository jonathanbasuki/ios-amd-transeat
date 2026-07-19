import SwiftUI

struct LocatingView: View {
    var body: some View {
        WatchContainer {
            MascotView(mascot: "mascot-detecting", isPulsing: true)
            
            ScreenTitleText(text: "Mendeteksi Alat TranSeat...")
            ScreenBodyText(text: "Pastikan ponsel Mama selalu dalam keadaan menyala, ya!")
        }
    }
}

#Preview {
    LocatingView()
}

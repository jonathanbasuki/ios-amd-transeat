import SwiftUI

struct AskSeatedView: View {
    var onConfirm: () -> Void = {}
    var onNotYet: () -> Void = {}

    var body: some View {
        WatchContainer {
            ScreenTitleText(text: "Mama sudah duduk?")

            PrimaryPillButton(title: "Sudah", action: onConfirm)
            SecondaryPillButton(title: "Belum", action: onNotYet)

            ScreenCaptionText(text: "Sisa waktu konfirmasi 30s")
        }
    }
}

#Preview {
    AskSeatedView()
}

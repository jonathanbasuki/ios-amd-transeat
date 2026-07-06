import SwiftUI

struct ConfirmSeatView: View {
    var onConfirm: () -> Void = {}
    var onNotYet: () -> Void = {}

    var body: some View {
        WatchContainer {
            ScreenTitleText(text: "Sudah dapat kursi?")

            PrimaryPillButton(title: "Sudah dapat", action: onConfirm)
            SecondaryPillButton(title: "Belum dapat", action: onNotYet)

            ScreenCaptionText(text: "Sisa waktu konfirmasi 30s")
        }
    }
}

#Preview {
    ConfirmSeatView()
}

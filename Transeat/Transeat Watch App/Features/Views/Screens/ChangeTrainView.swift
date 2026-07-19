import SwiftUI

struct ChangeTrainView: View {
    var onConfirm: () -> Void = {}
    var onLastTrain: () -> Void = {}

    var body: some View {
        WatchContainer {
            ScreenTitleText(text: "Mama akan ganti kereta?")

            PrimaryPillButton(title: "Iya", action: onConfirm)
            SecondaryPillButton(title: "Tidak", action: onLastTrain)

            ScreenCaptionText(text: "Sisa waktu konfirmasi 30s")
        }
    }
}

#Preview {
    ChangeTrainView()
}

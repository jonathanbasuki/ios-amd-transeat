import SwiftUI

struct CountdownNotSeatedView: View {
    let countdown: CountdownState

    var body: some View {
        WatchContainer {
            ScreenTitleText(text: "Belum dapat kursi?")

            CountdownView(
                label: "Estimasi waktu tunggu",
                formattedTime: countdown.formatted
            )

            ScreenCaptionText(text: "Kami akan membunyikan alat bantuan kembali.")
        }
    }
}

#Preview {
    CountdownNotSeatedView(countdown: CountdownState(remainingSeconds: 5 * 60))
}

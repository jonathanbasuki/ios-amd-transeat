import SwiftUI

struct CountdownSeatedView: View {
    let countdown: CountdownState

    var body: some View {
        WatchContainer {
            ScreenTitleText(text: "Kursi terkonfirmasi!")

            CountdownView(
                label: "Estimasi waktu tunggu",
                formattedTime: countdown.formatted
            )

            ScreenCaptionText(text: "Ingat untuk selalu konfirmasi kursi setiap 30 menit ya, Mama!")
        }
    }
}

#Preview {
    CountdownSeatedView(countdown: CountdownState(remainingSeconds: 30 * 60))
}

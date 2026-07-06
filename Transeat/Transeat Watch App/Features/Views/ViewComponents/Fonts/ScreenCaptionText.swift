import SwiftUI

struct ScreenCaptionText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.hexPalette.darkgray)
    }
}

#Preview {
    VStack(spacing: Spacing.sm) {
        ScreenCaptionText(text: "Remaining time to confirm 30s")
    }
}

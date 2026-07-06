import SwiftUI

struct CountdownView: View {
    let label: String
    let formattedTime: String
    var color: Color = .hexPalette.cherry500

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(label)
                .font(.sectionLabel)
                .foregroundStyle(Color.hexPalette.black)
                .multilineTextAlignment(.center)

            Text(formattedTime)
                .font(.countdown)
                .foregroundStyle(color)
                .monospacedDigit()
                .accessibilityLabel(Text("\(formattedTime) remaining"))
        }
    }
}

#Preview {
    CountdownView(label: "Estimated Renewal Time", formattedTime: "30:00")
}

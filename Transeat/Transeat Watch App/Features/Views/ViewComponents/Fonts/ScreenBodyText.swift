import SwiftUI

struct ScreenBodyText: View {
    let text: String
    var font: Font = .body
    var color: Color = .hexPalette.darkgray

    var body: some View {
        Text(text)
            .font(font)
            .multilineTextAlignment(.center)
            .foregroundStyle(color)
    }
}

#Preview {
    VStack(spacing: Spacing.sm) {
        ScreenBodyText(text: "Pastikan ponsel Mama selalu dalam keadaan menyala, ya!")
    }
}

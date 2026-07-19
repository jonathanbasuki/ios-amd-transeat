import SwiftUI

struct ProgressActionView: View {
    let image: String
    let title: String

    let primaryTitle: String
    let secondaryTitle: String

    let footer: String?

    let onPrimary: () -> Void
    let onSecondary: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.hexPalette.cherry500)
                .padding(.top, 8)

            Button(primaryTitle, action: onPrimary)
                .buttonStyle(PrimaryButtonStyle())

            Button(secondaryTitle, action: onSecondary)
                .buttonStyle(SecondaryButtonStyle())

            if let footer {
                Text(footer)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProgressActionView(
        image: "mascot-detected",
        title: "Title",
        primaryTitle: "Primary",
        secondaryTitle: "Secondary",
        footer: "Footer",
        onPrimary: { },
        onSecondary: { }
    )
}

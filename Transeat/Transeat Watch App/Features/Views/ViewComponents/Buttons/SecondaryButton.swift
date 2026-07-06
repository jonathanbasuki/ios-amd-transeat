import SwiftUI

struct SecondaryPillButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonLabel)
                .foregroundStyle(Color.hexPalette.cherry500)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
        }
        .background(
            RoundedRectangle(cornerRadius: Radius.pill)
                .stroke(Color.hexPalette.cherry500, lineWidth: 1.5)
        )
        .buttonStyle(.plain)
        .accessibilityIdentifier("secondaryPillButton_\(title)")
    }
}

#Preview {
    SecondaryPillButton(title: "Not Yet") {}
        .padding()
}

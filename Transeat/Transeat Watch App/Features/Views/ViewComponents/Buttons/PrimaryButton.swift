import SwiftUI

struct PrimaryPillButton: View {
    let title: String
    var action: () -> Void
 
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonLabel)
                .foregroundStyle(Color.hexPalette.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
        }
        .background(Color.hexPalette.cherry500)
        .clipShape(RoundedRectangle(cornerRadius: Radius.pill))
        .buttonStyle(.plain)
        .accessibilityIdentifier("primaryPillButton_\(title)")
    }
}
 
#Preview {
    PrimaryPillButton(title: "Yes") {}
        .padding()
}

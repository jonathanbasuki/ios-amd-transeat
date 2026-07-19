import SwiftUI

struct ScreenTitleText: View {
    let text: String
    var color: Color = .hexPalette.cherry500
 
    var body: some View {
        Text(text)
            .font(.screenTitle)
            .multilineTextAlignment(.center)
            .foregroundStyle(color)
            .accessibilityAddTraits(.isHeader)
    }
}
 
#Preview {
    ScreenTitleText(text: "Welcome on board, Mama!")
}

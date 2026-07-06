import SwiftUI

struct WatchContainer<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.sm) {
                content
            }
            .padding(.horizontal, Spacing.sm)
            .frame(maxWidth: .infinity)
        }
        .background(Color.hexPalette.white)
    }
}

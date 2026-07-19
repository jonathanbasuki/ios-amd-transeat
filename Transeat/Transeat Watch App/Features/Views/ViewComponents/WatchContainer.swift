import SwiftUI

struct WatchContainer<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: Spacing.sm) {
            content
        }
        .padding(.horizontal, Spacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.hexPalette.white)
    }
}

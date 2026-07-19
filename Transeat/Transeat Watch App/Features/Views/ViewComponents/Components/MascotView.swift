import SwiftUI

struct MascotView: View {
    var mascot: String = "mascot-default"
    var isPulsing: Bool = false
    var size: CGFloat = 54

    @State private var animate = false

    var body: some View {
        ZStack {
            if isPulsing {
                ForEach(0..<2, id: \.self) { index in
                    Circle()
                        .stroke(Color.hexPalette.cherry300, lineWidth: 2)
                        .frame(width: size, height: size)
                        .scaleEffect(animate ? 2 : 1)
                        .opacity(animate ? 0 : 0.6)
                        .animation(
                            .easeOut(duration: 1.6)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.5),
                            value: animate
                        )
                }
            }

            Image(mascot)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .accessibilityLabel(Text("TranSeat mascot"))
        }
        .onAppear { animate = isPulsing }
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        MascotView(mascot: "mascot-default", isPulsing: false)
        MascotView(isPulsing: true)
    }
}

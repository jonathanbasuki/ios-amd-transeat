import SwiftUI

struct ProgressView: View {
    let mascot: String
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 8) {
            
            Image(mascot)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(Color.hexPalette.cherry500)
            
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.hexPalette.cherry500)
                .padding(.top, 8)
            
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    ProgressView(mascot: "mascot-detected", title: "Sudah duduk", subtitle: "Iya, sudah")
}

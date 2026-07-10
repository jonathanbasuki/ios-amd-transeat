import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("mascot-default")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .foregroundColor(Color.hexPalette.cherry500)

            VStack(spacing: 12) {
                Text("Yuk, Verifikasi Kehamilan")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text("Lengkapi data Mama untuk mulai menggunakan TranSeat.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.hexPalette.darkgray)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            NavigationLink(destination: ValidatePregnancyView()) {
                Text("Verifikasi Kehamilan")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(24)
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingView()
}

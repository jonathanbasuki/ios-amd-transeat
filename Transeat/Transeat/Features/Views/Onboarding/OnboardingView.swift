//
//  OnboardingView.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 06/07/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image("mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .foregroundColor(Color.hexPalette.cherry500)

                VStack(spacing: 12) {
                    Text("Sudahkah Mama\nvalidasi kehamilan?")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("Kami butuh mengonfirmasi data Mama sebelum\npakai TranSeat. Mohon isi data Mama dulu!")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.hexPalette.darkgray)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                NavigationLink(destination: ValidatePregnancyView()) {
                    Text("Validasi Kehamilan")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    OnboardingView()
}

//
//  HomeCenterContentView.swift
//  transeatluv
//
//  Content shown for the non-modal states: .home, .goToSeat, .endTrip.
//

import SwiftUI

struct HomeCenterContentView: View {
    let state: HomeState

    var body: some View {
        switch state {
        case .home:
            VStack(spacing: 16) {
                // Replace with your cherry asset if available
                Image("mascot-detecting")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(Color.hexPalette.cherry500)

                Text("Kita sedang mencarimu\nMama!")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.hexPalette.cherry500)

                Text("Pastikan ponsel selalu dalam keadaan menyala")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }

        case .goToSeat:
            VStack(spacing: 16) {
                Image("mascot-detected")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Text("Menujulah ke kursi\nprioritas terdekat")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.hexPalette.cherry500)

                Text("Pastikan ponsel selalu dalam keadaan menyala")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }

        case .endTrip:
            VStack(spacing: 16) {
                Image("mascot-hai")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Text("Nikmati perjalanan\nMama!")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.hexPalette.cherry500)

                Text("Pakailah kami lagi pada perjalanan Anda berikutnya.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }

        default:
            EmptyView()
        }
    }
}

#Preview {
    HomeCenterContentView(state: .home)
}

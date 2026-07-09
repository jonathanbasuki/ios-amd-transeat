//
//  HomeModalCardView.swift
//  transeatluv
//
//  The dimmed-background modal cards for the interactive states:
//  .beaconDetected, .changeTrain, .seatConfirmDelay, .seatUnconfirmDelay.
//

import SwiftUI

struct HomeModalCardView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            switch viewModel.currentState {
            case .beaconFound:
                CardContainer {
                    Image("mascot-askseated")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text("Sudah dapat kursi?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)

                    Button(action: { viewModel.confirmSeated() }) {
                        PillButtonLabel(text: "Sudah", primary: true)
                    }

                    Button(action: { viewModel.triggerUnconfirmDelayFlow() }) {
                        PillButtonLabel(text: "Belum", primary: false)
                    }

                    Text("Sisa waktu konfirmasi: 20s")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

            case .changeTrain:
                CardContainer {
                    Image("train")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Mama akan ganti kereta?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)

                    Button(action: { viewModel.confirmChangingTrain() }) {
                        PillButtonLabel(text: "Iya, saya akan ganti kereta", primary: true)
                    }

                    Button(action: { viewModel.declineChangingTrain() }) {
                        PillButtonLabel(text: "Tidak, ini kereta terakhir saya", primary: false)
                    }
                }

            case .seatConfirmDelay:
                CardContainer {
                    Image("mascot-seated")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text("Kursi Terkonfirmasi!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                    Text("Estimasi Waktu Tunggu")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Text("30:00")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                }

            case .seatUnconfirmDelay:
                CardContainer {
                    Image("mascot-notseated")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text("Belum dapat tempat duduk?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                    Text("Estimasi Waktu Tunggu")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Text("05:00")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                }

            default:
                EmptyView()
            }
        }
        .padding(.horizontal, 30)
    }
}

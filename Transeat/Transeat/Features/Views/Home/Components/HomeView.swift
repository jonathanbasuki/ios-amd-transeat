//
//  HomeView.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 03/07/26.
//

import SwiftUI

// MARK: - App State Machine
enum HomeState {
    case home
    case beaconFound
    case beaconNotFound
    case goToSeat
    case seatConfirmDelay
    case seatUnconfirmDelay
    case endTrip
    case askSeated
    case changeTrain
}

struct HomeView: View {
    var expectedDueDate: String = ""

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            // 1. Core Background Content
            VStack {
                Spacer()
                fullPageContentView
                Spacer()
            }
            .blur(radius: isModalState ? 3 : 0)
            .animation(.easeInOut, value: viewModel.currentState)

            // 2. Dimmed Overlay + Interactive Modal Cards
            if isModalState {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)

                modalCardOverlayView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // 3. Independent Header Layer (Always on top and clickable)
            VStack {
                headerView
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startTestingFlow()
            viewModel.onAppear() // starts the beacon + syncs Watch to "locating"
        }
        .onDisappear {
            viewModel.onDisappear() // stops the beacon
        }
        // Monitors state changes to: (1) run the ViewModel's beacon/Watch-sync
        // side effects, and (2) handle the automatic popup dismissal sequence.
        .onChange(of: viewModel.currentState) { oldValue, newValue in
            viewModel.onStateChanged(to: newValue)

            if newValue == .seatConfirmDelay {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        viewModel.currentState = .endTrip
                    }
                }
            }
        }
    }
}

// MARK: - View Layout Branches
extension HomeView {

    @ViewBuilder
    private var fullPageContentView: some View {
        switch viewModel.currentState {
        case .home:
            FullPageLayout(imageName: "mascot-detecting", title: "Kita sedang mencarimu\nMama!", subtitle: "Pastikan ponsel selalu dalam keadaan menyala")
        case .beaconFound:
            FullPageLayout(imageName: "mascot-detected", title: "Kita menemukan Mama!", subtitle: "Pastikan ponsel selalu dalam keadaan menyala", badgeType: .confirmed)
        case .beaconNotFound:
            FullPageLayout(imageName: "mascot-notdetected", title: "Kita tidak menemukan\nMama!", subtitle: "Pastikan ponsel selalu dalam keadaan menyala", badgeType: .notFound)
        case .goToSeat, .seatConfirmDelay:
            FullPageLayout(imageName: "mascot-chair", title: "Menujulah ke kursi\nprioritas terdekat", subtitle: "Pastikan ponsel selalu dalam keadaan menyala")
        case .seatUnconfirmDelay:
            FullPageLayout(imageName: "mascot-notseated", title: "Belum dapat tempat duduk?", subtitle: "Tunggu sebentar ya, kami akan mencarikan lagi.")
        case .endTrip:
            FullPageLayout(imageName: "mascot-hai", title: "Nikmati perjalanan\nMama!", subtitle: "Pakailah kami lagi pada perjalanan Anda berikutnya.")
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var modalCardOverlayView: some View {
        VStack {
            switch viewModel.currentState {
            case .askSeated:
                ModalCardContainer {
                    HomeIconView(imageName: "mascot-askseated")
                    Text("Sudah dapat kursi?").font(.system(size: 20, weight: .bold)).foregroundColor(Color.hexPalette.cherry500)
                    FlowButton(text: "Sudah", primary: true) { viewModel.confirmSeated() }
                    FlowButton(text: "Belum", primary: false) { viewModel.triggerUnconfirmDelayFlow() }
                    Text("Sisa waktu konfirmasi: 20s").font(.system(size: 12)).foregroundColor(.gray)
                }
            case .changeTrain:
                ModalCardContainer {
                    HomeIconView(imageName: "train")
                    Text("Mama akan ganti kereta?").font(.system(size: 20, weight: .bold)).foregroundColor(Color.hexPalette.cherry500)
                    FlowButton(text: "Iya, saya akan ganti kereta", primary: true) { viewModel.confirmChangingTrain() }
                    FlowButton(text: "Tidak, ini kereta terakhir saya", primary: false) { viewModel.declineChangingTrain() }
                }
            case .seatConfirmDelay:
                ModalCardContainer {
                    HomeIconView(imageName: "mascot-seated")
                    Text("Kursi Terkonfirmasi!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                }
            default:
                EmptyView()
            }
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Logic, Timers, & Configurations
extension HomeView {
    private var isModalState: Bool {
        return viewModel.currentState == .askSeated || viewModel.currentState == .changeTrain || viewModel.currentState == .seatConfirmDelay
    }

    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Halo, Mama!").font(.system(size: 22, weight: .bold)).foregroundColor(.black)
                Text("Expected Due Date : \(expectedDueDate)").font(.system(size: 13)).foregroundColor(Color.hexPalette.darkgray)
            }
            Spacer()

            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color.hexPalette.cherry500)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(20)
    }

    private func startTestingFlow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            withAnimation { viewModel.currentState = .beaconFound }

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation { viewModel.currentState = .goToSeat }

                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation { viewModel.currentState = .askSeated }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

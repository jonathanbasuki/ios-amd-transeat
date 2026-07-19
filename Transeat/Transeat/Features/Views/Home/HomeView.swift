import SwiftUI

struct HomeView: View {
    var expectedDueDate: String = ""

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            VStack {
                fullPageContentView
            }

            VStack {
                headerView
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startTestingFlow()
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .onChange(of: viewModel.currentState) { _, newValue in
            viewModel.onStateChanged(to: newValue)

            if newValue == .seatConfirmed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        viewModel.currentState = .enjoyTrip
                    }
                }
            }
        }
    }
}

// MARK: - View Layout
extension HomeView {
    @ViewBuilder
    private var fullPageContentView: some View {
        switch viewModel.currentState {

        case .home:
            ProgressView(
                mascot: "mascot-detecting",
                title: "Mendeteksi alat TranSeat di sekitar Mama...",
                subtitle: "Pastikan ponsel selalu dalam keadaan menyala, ya!"
            )

        case .beaconFound:
            ProgressView(
                mascot: "mascot-detected",
                title: "Kursi ditemukan!",
                subtitle: "Silahkan menuju gerbong 4!"
            )

        case .beaconNotFound:
            ProgressView(
                mascot: "mascot-notdetected",
                title: "Kursi penuh!\nMencari kursi lain...",
                subtitle: "Pastikan ponsel selalu dalam keadaan menyala."
            )

        case .goToSeat:
            ProgressView(
                mascot: "mascot-chair",
                title: "Silakan menuju kursi prioritas yang tersedia.",
                subtitle: "Pastikan ponsel selalu dalam keadaan menyala!"
            )

        case .askSeated:
            ProgressActionView(
                image: "mascot-askseated",
                title: "Mama sudah duduk?",
                primaryTitle: "Sudah",
                secondaryTitle: "Belum",
                footer: "Sisa waktu konfirmasi: 20s",
                onPrimary: viewModel.confirmSeated,
                onSecondary: viewModel.triggerUnconfirmDelayFlow
            )

        case .changeTrain:
            ProgressActionView(
                image: "train",
                title: "Mama akan ganti kereta?",
                primaryTitle: "Iya, saya akan ganti kereta",
                secondaryTitle: "Tidak, ini kereta terakhir saya",
                footer: "Aplikasi tidak akan mengirimkan sinyal lagi jika ini adalah perjalanan KRL terakhir Anda.",
                onPrimary: viewModel.confirmChangingTrain,
                onSecondary: viewModel.declineChangingTrain
            )

        case .seatConfirmed:
            ProgressView(
                mascot: "mascot-seated",
                title: "Kursi Terkonfirmasi!",
                subtitle: nil
            )

        case .seatNotConfirmed:
            ProgressView(
                mascot: "mascot-notseated",
                title: "Belum dapat tempat duduk?",
                subtitle: "Tunggu sebentar ya, kami akan mencarikan lagi!"
            )

        case .enjoyTrip:
            ProgressView(
                mascot: "mascot-hai",
                title: "Nikmati perjalanan Mama!",
                subtitle: "Pakailah kami lagi pada perjalanan Anda berikutnya."
            )
        }
    }
}

// MARK: - Helpers
extension HomeView {
    private var headerView: some View {
        HomeHeaderView(expectedDueDate: expectedDueDate)
    }

    private func startTestingFlow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            withAnimation {
                viewModel.currentState = .beaconFound
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    viewModel.currentState = .goToSeat
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation {
                        viewModel.currentState = .askSeated
                    }
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

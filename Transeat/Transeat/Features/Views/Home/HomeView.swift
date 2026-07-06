//
//  HomeViewController.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 03/07/26.
//

import SwiftUI

// 1. Define the possible view states for your flow
enum HomeState {
    case home
    case goToSeat
    case beaconDetected
    case changeTrain
    case seatConfirmDelay
    case seatUnconfirmDelay
    case endTrip
}

struct HomeView: View {
    var expectedDueDate: String = "12/04/2027"
    
    // Track current flow state
    @State private var currentState: HomeState = .home
    
    var body: some View {
        ZStack {
            // Background & Header Layout (Always present)
            VStack(spacing: 0) {
                headerView
                
                Spacer()
                
                // Content changes based on simple state or final state
                centerContentView
                
                Spacer()
            }
            .blur(radius: isModalState ? 2 : 0) // Optional subtle blur when modal is up
            
            // 2. Dimmed Overlay + Modal Cards for Interactive States
            if isModalState {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    
                modalCardView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startTestingFlow()
        }
    }
}

// MARK: - Subviews & Layout Components
extension HomeView {
    
    // Header component
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Halo, Mama!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                Text("Expected Due Date : \(expectedDueDate)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.hexPalette.darkgray)
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(Color.hexPalette.cherry500)
        }
        .padding(20)
    }
    
    // Center Content for non-modal states (Home, GoToSeat, EndTrip)
    @ViewBuilder
    private var centerContentView: some View {
        switch currentState {
        case .home:
            VStack(spacing: 16) {
                // Replace with your cherry asset if available
                Image("mascot-locating")
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
                Image("mascot-locating")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(Color.hexPalette.cherry500)
                
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
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color.hexPalette.cherry500)
                
                Text("Nikmati perjalanan\nMama!")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.hexPalette.cherry500)
                
                Text("Pakailah kami lagi pada perjalanan Anda berikutnya.")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
        default:
            EmptyView()
        }
    }
    
    // Modal Cards Switcher
    @ViewBuilder
    private var modalCardView: some View {
        VStack {
            switch currentState {
            case .beaconDetected:
                cardContainer {
                    Image("mascot-located")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text("Sudah dapat kursi?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                    
                    Button(action: { currentState = .changeTrain }) {
                        buttonLabel("Sudah", primary: true)
                    }
                    
                    Button(action: { triggerUnconfirmDelayFlow() }) {
                        buttonLabel("Belum", primary: false)
                    }
                    
                    Text("Sisa waktu konfirmasi: 20s")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
            case .changeTrain:
                cardContainer {
                    Image("mascot-located")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text("Mama akan ganti kereta?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                    
                    Button(action: { currentState = .seatConfirmDelay }) {
                        buttonLabel("Iya, saya akan ganti kereta", primary: true)
                    }
                    
                    Button(action: { currentState = .endTrip }) {
                        buttonLabel("Tidak, ini kereta terakhir saya", primary: false)
                    }
                }
                
            case .seatConfirmDelay:
                cardContainer {
                    Image("mascot-seated")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
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
                cardContainer {
                    Image("mascot-notseated")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
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

// MARK: - Logic & Helper Computations
extension HomeView {
    
    // Helper to determine if the active state requires a dimmed modal layout
    private var isModalState: Bool {
        switch currentState {
        case .beaconDetected, .changeTrain, .seatConfirmDelay, .seatUnconfirmDelay:
            return true
        default:
            return false
        }
    }
    
    // Automated flow steps via Async Timers
    private func startTestingFlow() {
        // Step 1: Default is .home. Transition to .goToSeat after 5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation { currentState = .goToSeat }
            
            // Step 2: Transition from .goToSeat to .beaconDetected after 5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation { currentState = .beaconDetected }
            }
        }
    }
    
    // Handles loop for "Belum" selection
    private func triggerUnconfirmDelayFlow() {
        withAnimation { currentState = .seatUnconfirmDelay }
        
        // After 5 seconds, route back to Beacon Detected
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation { currentState = .beaconDetected }
        }
    }
    
    // Reusable styling for modal cards
    private func cardContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 20) {
            // Icon Placeholder for Cherry graphic assets
            Image(systemName: "cherry.fill")
                .font(.system(size: 44))
                .foregroundColor(Color.hexPalette.cherry500)
                .padding(.top, 10)
                
            content()
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    // Reusable custom buttons matching wireframe layout
    private func buttonLabel(_ text: String, primary: Bool) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(primary ? .white : Color.hexPalette.cherry500)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(primary ? Color.hexPalette.cherry500 : Color.white)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.hexPalette.cherry500, lineWidth: primary ? 0 : 1)
            )
    }
}

#Preview {
    HomeView()
}

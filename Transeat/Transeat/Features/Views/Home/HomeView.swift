//
//  HomeViewController.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 03/07/26.
//

import SwiftUI

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

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            // Background & Header Layout (Always present)
            VStack(spacing: 0) {
                HomeHeaderView(expectedDueDate: expectedDueDate)

                Spacer()

                HomeCenterContentView(state: viewModel.currentState)

                Spacer()
            }
            .blur(radius: viewModel.isModalVisible ? 2 : 0)

            // Dimmed Overlay + Modal Card for interactive states
            if viewModel.isModalVisible {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.dismissModal()
                    }

                HomeModalCardView(viewModel: viewModel)
                    .offset(y: max(0, viewModel.dragOffset))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                viewModel.updateDrag(value.translation.height)
                            }
                            .onEnded { value in
                                viewModel.endDrag(value.translation.height)
                            }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .onChange(of: viewModel.currentState) { _, newState in
            viewModel.onStateChanged(to: newState)
        }
    }
}

#Preview {
    HomeView()
}

//
//  CameraDetectionView.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import SwiftUI

struct CameraDetectionView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("KRL Cam")
                .font(.title2)
                .fontWeight(.bold)

            ZStack {
                CameraPreviewView(session: viewModel.cameraManager.session)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                BoundingBoxOverlayView(persons: viewModel.personDetector.detectedPersons)

                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray, lineWidth: 1)
            }
            .frame(height: 480)
            .padding(.horizontal)
            

            VStack(spacing: 8) {
                Text("Seat Occupancy Status")
                    .font(.headline)
                StatusBadgeView(
                    text: viewModel.isSeatAvailable ? "Seat Available" : "Seat Full",
                    color: viewModel.isSeatAvailable ? .green : .red
                )
            }

            VStack(spacing: 8) {
                Text("Beacon Status")
                    .font(.headline)
                StatusBadgeView(
                    text: viewModel.beaconManager.isOn ? "ON" : "OFF",
                    color: viewModel.beaconManager.isOn ? .green : .red
                )
            }

            Spacer()

        }
        .onAppear { viewModel.start() }
    }
}

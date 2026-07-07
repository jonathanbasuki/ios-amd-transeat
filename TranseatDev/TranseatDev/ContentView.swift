//
//  ContentView.swift
//  TranseatDev
//
//  Created by Jonathan Basuki on 01/07/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        switch viewModel.screenState {
        case .camera:
            CameraDetectionView(viewModel: viewModel)
        case .signalReceived:
            SignalReceivedView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}

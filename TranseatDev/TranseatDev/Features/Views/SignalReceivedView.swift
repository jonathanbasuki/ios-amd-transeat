//
//  SignalReceivedView.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import SwiftUI

struct SignalReceivedView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        cardContainer {
            Image("mascot-located")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Menunggu konfirmasi...")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.hexPalette.cherry500)

            Text("Konfirmasi dari perangkat lain akan otomatis muncul di sini")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}



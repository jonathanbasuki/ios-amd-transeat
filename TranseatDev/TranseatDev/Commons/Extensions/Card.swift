//
//  Card.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 07/07/26.
//
import SwiftUI

extension SignalReceivedView {
    func cardContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
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
}

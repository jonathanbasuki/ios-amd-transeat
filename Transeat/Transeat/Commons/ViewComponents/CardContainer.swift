//
//  CardContainer.swift
//  transeatluv
//
//  Reusable styling wrapper for modal cards, plus the pill-shaped
//  button label used inside them.
//

import SwiftUI

struct CardContainer<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cherry.fill")
                .font(.system(size: 44))
                .foregroundColor(Color.hexPalette.cherry500)
                .padding(.top, 10)

            content
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

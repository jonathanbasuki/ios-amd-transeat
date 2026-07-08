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
            // Icon Placeholder for Cherry graphic assets
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

/// Reusable custom button label matching the wireframe layout.
struct PillButtonLabel: View {
    let text: String
    let primary: Bool

    var body: some View {
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
    CardContainer {
        Text("Preview content")
        PillButtonLabel(text: "Sudah", primary: true)
        PillButtonLabel(text: "Belum", primary: false)
    }
    .padding()
}

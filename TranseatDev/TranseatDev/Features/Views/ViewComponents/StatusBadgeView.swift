//
//  StatusBadgeView.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import SwiftUI


struct StatusBadgeView: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(color)
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBadgeView(text: "Seat Available", color: .green)
        StatusBadgeView(text: "Seat Full", color: .red)
        StatusBadgeView(text: "ON", color: .green)
        StatusBadgeView(text: "OFF", color: .red)
    }
}

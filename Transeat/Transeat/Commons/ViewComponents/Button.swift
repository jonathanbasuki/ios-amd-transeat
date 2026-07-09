//
//  Button.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 04/07/26.
//

import SwiftUI

/// Primary button
struct PrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isDisabled ? Color.hexPalette.gray : Color.hexPalette.cherry500)
            .clipShape(Capsule())
            .opacity(configuration.isPressed && !isDisabled ? 0.8 : 1.0)
    }
}

/// Secondary button
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.hexPalette.cherry500)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .stroke(Color.hexPalette.cherry500, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}


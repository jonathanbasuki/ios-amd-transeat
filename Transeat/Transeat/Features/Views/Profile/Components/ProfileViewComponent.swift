//
//  ProfileViewComponent.swift
//  Transeat
//
//  Created by Gabriella Erlinda on 08/07/26.
//

import SwiftUI

// MARK: - Reusable Profile Card Field
struct ProfileInputField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    /// When true, the field is read-only (grayed out, can't be edited).
    /// Used for fields like "Hari Perkiraan Lahir" that shouldn't be
    /// changed from ProfileView.
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .disabled(isDisabled)
                .font(.system(size: 15))
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(isDisabled ? Color(.systemGray5) : Color(.systemGray6))
                .cornerRadius(8)
                .foregroundColor(isDisabled ? .gray : .black)
        }
    }
}

// MARK: - Medical Attachment Row Document Card
struct MedicalProofRow: View {
    let title: String
    let fallbackImageName: String
    /// The actual uploaded proof image from SwiftData, if any. When nil,
    /// the fallback placeholder image is shown instead.
    var imageData: Data? = nil
    /// Called when the row is tapped — used to present the image picker.
    var onTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)

            Button(action: onTap) {
                HStack(spacing: 12) {
                    proofThumbnail

                    Spacer()
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var proofThumbnail: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .cornerRadius(6)
                .clipped()
        } else {
            Image(fallbackImageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .background(Color.black.opacity(0.05))
                .cornerRadius(6)
                .clipped()
        }
    }
}

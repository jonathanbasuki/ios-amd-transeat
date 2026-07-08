//
//  UploadCard.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 03/07/26.
//


import SwiftUI

struct UploadCard: View {
    let title: String
    @Binding var isUploaded: Bool

    @State private var showActionSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            Button {
                showActionSheet = true
            } label: {
                if isUploaded {
                    uploadedContent
                } else {
                    emptyContent
                }
            }
            .buttonStyle(.plain)
        }
        .confirmationDialog("Select file/take a picture to upload", isPresented: $showActionSheet, titleVisibility: .hidden) {
            Button("Photo Library") { simulateUpload() }
            Button("Take Photo") { simulateUpload() }
            Button("Choose File") { simulateUpload() }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func simulateUpload() {
        withAnimation {
            isUploaded = true
        }
    }

    private var emptyContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(.black)

            Text("Pilih file atau ambil foto untuk diunggah.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text("Format yang didukung: PNG, JPG, JPEG, PDF")
                .font(.system(size: 13))
                .foregroundColor(.hexPalette.darkgray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .foregroundColor(Color.hexPalette.gray)
        )
    }

    /// Placeholder "uploaded" preview — swap the fill for a real Image/AsyncImage once
    /// actual picker + storage is wired up.
    private var uploadedContent: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .foregroundColor(Color.hexPalette.gray)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                )

            Image(systemName: "photo.fill")
                .font(.system(size: 36))
                .foregroundColor(.white.opacity(0.55))
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

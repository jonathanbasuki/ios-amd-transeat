//
//  ValidatePregnancyView.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 06/07/26.
//

import SwiftUI

struct ValidatePregnancyView: View {
    @State private var isUSGUploaded = false
    @State private var isMedicationUploaded = false
    @State private var goToData = false

    private var isFormComplete: Bool {
        isUSGUploaded && isMedicationUploaded
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    UploadCard(title: "USG Proof", isUploaded: $isUSGUploaded)
                    UploadCard(title: "Newest Medication Proof", isUploaded: $isMedicationUploaded)
                }
                .padding(20)
            }

            Divider()

            Button {
                goToData = true
            } label: {
                Text("Konfirmasi")
            }
            .buttonStyle(PrimaryButtonStyle(isDisabled: !isFormComplete))
            .disabled(!isFormComplete)
            .padding(20)
        }
        .navigationTitle("Validasi Kehamilan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $goToData) {
            ValidateDataView()
        }
    }
}

#Preview {
    NavigationStack {
        ValidatePregnancyView()
    }
}

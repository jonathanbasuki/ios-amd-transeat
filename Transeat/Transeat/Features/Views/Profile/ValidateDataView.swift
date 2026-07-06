//
//  ValidateDataView.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 06/07/26.
//


import SwiftUI

struct ValidateDataView: View {
    // the extracted USG / medication proof documents.
    @State private var name: String = "Kartini"
    @State private var age: String = "36"
    @State private var edd: String = "12/04/2027"

    @State private var goToHome = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("This form is autofill by document uploaded")
                        .font(.system(size: 13))
                        .foregroundColor(Color.hexPalette.darkgray)

                    labeledField(title: "Name", text: $name)
                    labeledField(title: "Age", text: $age, keyboardType: .numberPad)

                    VStack(alignment: .leading, spacing: 8) {
                        labeledField(title: "Expected Due Date (EDD)", text: $edd)
                        Text("This due date will determine the expiration date of the app")
                            .font(.system(size: 13))
                            .foregroundColor(Color.hexPalette.darkgray)
                    }
                }
                .padding(20)
            }

            Divider()

            Button {
                goToHome = true
            } label: {
                Text("Konfirmasi")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(20)
        }
        .navigationTitle("Validasi Kehamilan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $goToHome) {
            HomeView()
        }
    }

    @ViewBuilder
    private func labeledField(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            TextField(title, text: text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.hexPalette.lightgray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    NavigationStack {
        ValidateDataView()
    }
}

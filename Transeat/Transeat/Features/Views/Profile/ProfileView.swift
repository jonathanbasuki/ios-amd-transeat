//
//  ProfileView.swift
//  Transeat
//
//  Created by Gabriella Erlinda on 08/07/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var profileName: String = "Kartini"
    @State private var profileAge: String = "36"
    @State private var profileEDD: String = "12/04/2027"
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Row Headers
            profileHeaderView
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // 1. Image Upload Attachments Blocks
                    VStack(spacing: 18) {
                        MedicalProofRow(title: "USG Proof", fallbackImageName: "usg-placeholder")
                        MedicalProofRow(title: "Newest Medication Proof", fallbackImageName: "usg-placeholder")
                    }
                    
                    // 2. Personal Biographical Profiles TextFields
                    VStack(spacing: 16) {
                        ProfileInputField(label: "Name", text: $profileName)
                        ProfileInputField(label: "Age", text: $profileAge)
                        ProfileInputField(label: "Expected Due Date (EDD)", text: $profileEDD)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            
            Spacer()
            
            // Bottom Form Commitment Button Actions
            saveProfileButton
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Interface View Subcomponents Layouts
extension ProfileView {
    
    private var profileHeaderView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                }
                
                Spacer()
                
                Text("Profil Mama")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Balance Layout item
                Image(systemName: "chevron.left").opacity(0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Divider()
        }
    }
    
    private var saveProfileButton: some View {
        Button(action: {
            // Save operations trigger safely here
            dismiss()
        }) {
            Text("Simpan Perubahan")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.hexPalette.cherry500)
                .cornerRadius(25)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

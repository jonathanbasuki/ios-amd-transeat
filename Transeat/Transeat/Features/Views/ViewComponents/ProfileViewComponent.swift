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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .foregroundColor(.black)
        }
    }
}

// MARK: - Medical Attachment Row Document Card
struct MedicalProofRow: View {
    let title: String
    let fallbackImageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                // Left Image Element Thumbnail Placeholder
                Image(fallbackImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 44)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(6)
                    .clipped()
                
                Image(fallbackImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 44)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(6)
                    .clipped()
                
                Spacer()
                
                // Add / Edit Button
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
            
            Divider()
        }
    }
}

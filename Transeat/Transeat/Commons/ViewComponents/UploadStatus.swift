//
//  UploadStatus.swift
//  Transeat
//
//  Created by Naila Lauza on 09/07/26.
//

import SwiftUI

enum UploadStatus {
    case success
    case warning
    case error
    
    var title: String {
        switch self {
        case .success: return "Berhasil!"
        case .warning: return "Peringatan!"
        case .error: return "Error!"
        }
    }
    
    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .success: return Color(red: 0.18, green: 0.62, blue: 0.45)
        case .warning: return Color(red: 0.65, green: 0.43, blue: 0.12)
        case .error: return Color(red: 0.69, green: 0.17, blue: 0.21)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return Color(red: 0.92, green: 0.98, blue: 0.95)
        case .warning: return Color(red: 1.0, green: 0.97, blue: 0.88)
        case .error: return Color(red: 0.99, green: 0.91, blue: 0.92)
        }
    }
}

struct NotificationBanner: View {
    let type: UploadStatus
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: type.iconName)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(type.themeColor.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(type.themeColor)
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(type.themeColor.opacity(0.9))
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(type.backgroundColor))
    }
}

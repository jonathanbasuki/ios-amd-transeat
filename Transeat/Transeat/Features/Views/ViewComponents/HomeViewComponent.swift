//
//  HomeViewComponents.swift
//  Transeat
//
//  Created by Gabriella Erlinda on 08/07/26.
//

import SwiftUI

// MARK: - Generic Icon System with Badges
struct HomeIconView: View {
    let imageName: String
    var badgeType: BadgeType? = nil
    
    enum BadgeType {
        case confirmed
        case notFound
        case asking
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
            
            if let badge = badgeType {
                Group {
                    switch badge {
                    case .confirmed:
                        Image("mascot-detected")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color.hexPalette.cherry500)
                    case .notFound:
                        Image("mascot-notdetected")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color.hexPalette.cherry500)
                    case .asking:
                        Image("mascot-askseated")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color.hexPalette.cherry500)
                    }
                }
                .font(.system(size: 36, weight: .bold))
                .background(Color.white.clipShape(Circle()))
                .offset(x: 10, y: -10)
            }
        }
    }
}

// MARK: - Full Page Layout Template
struct FullPageLayout: View {
    let imageName: String
    let title: String
    let subtitle: String
    var badgeType: HomeIconView.BadgeType? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            HomeIconView(imageName: imageName, badgeType: badgeType)
            
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.hexPalette.cherry500)
            
            Text(subtitle)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

//// MARK: - Full Page Timer Layout Template
//struct FullPageTimerLayout: View {
//    let imageName: String
//    let title: String
//    let timeString: String
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            HomeIconView(imageName: imageName)
//                .frame(width: 150, height: 150)
//            
//            Text(title)
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(Color.hexPalette.cherry500)
//                .multilineTextAlignment(.center)
//            
//            Text("Estimasi Waktu Tunggu")
//                .font(.system(size: 15))
//                .foregroundColor(.gray)
//            
//            Text(timeString)
//                .font(.system(size: 44, weight: .bold))
//                .foregroundColor(Color.hexPalette.cherry500)
//        }
//    }
//}

// MARK: - Reusable Modal Container Card
struct ModalCardContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(spacing: 20) {
            content()
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Interactive Flow Button
struct FlowButton: View {
    let text: String
    let primary: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
}

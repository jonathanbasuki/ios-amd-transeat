//
//  UploadSucces.swift
//  Transeat
//
//  Created by Naila Lauza on 09/07/26.
//

//import SwiftUI
//
//struct UploadSucces: View {
//    var body: some View {
//        CardContainer {
//            Image("mascot-detected")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 140, height: 140)
//                .foregroundColor(Color.hexPalette.cherry500)
//
//            Text("Data Anda Telah Tersimpan")
//                .font(.system(size: 26, weight: .bold))
//                .foregroundColor(.black)
//                .multilineTextAlignment(.center)
//        }
//    }
//}

import SwiftUI

struct UploadSucces: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            CardContainer {
                VStack(spacing: 16) {
                    Image("mascot-detected")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                    
                    Text("Data Anda Telah Tersimpan")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
            }
            .frame(maxWidth: 300) 
        }
    }
}

#Preview {
    UploadSucces()
}

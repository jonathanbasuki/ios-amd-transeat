//
//  Guideline.swift
//  Transeat
//
//  Created by Naila Lauza on 09/07/26.
//

import SwiftUI

struct Guideline: View {
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10)
                    {
                        Text("Halo, Mama!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        Text("Kami menjaga data mu dengan aman. Informasi yang anda unggah hanya untuk mendukung pengalaman kehamilan Mama di aplikasi ini.")
                            .font(.system(size: 14))
                            .foregroundColor(Color.hexPalette.darkgray)
                            .padding(.bottom, 10)
                        Text("Cara Penggunaan Transeat :")
                            .font(.system(size: 24, weight: .bold))
                        HStack {
                            Rectangle()
                                .frame(width: 87, height: 87)
                                .cornerRadius(17)
                                .foregroundColor(.gray .opacity(0.3))
                            Text("Pastikan Mama sudah menunggu di peron di radius 100m")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black)
                        }
                        HStack {
                            Rectangle()
                                .frame(width: 87, height: 87)
                                .cornerRadius(17)
                                .foregroundColor(.gray .opacity(0.3))
                            Text("Kami menjaga data mu dengan aman. Informasi yang anda unggah hanya untuk mendukung pengalaman kehamilan Mama di aplikasi ini.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black)
                        }
                        Spacer()
                    
                }
            }
        }
        .padding(20)
        .navigationTitle("Panduan Penggunaan")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    Guideline()
}

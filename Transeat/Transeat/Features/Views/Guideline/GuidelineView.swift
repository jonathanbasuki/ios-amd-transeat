import SwiftUI
import UIKit
import SwiftData

struct GuidelineView: View {
    @Query private var profiles: [UserProfileModel]
    
    @State private var goToHome = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                        Text("Halo, Mama!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                    
                        Text("Kami menjaga data mu dengan aman. Informasi yang anda unggah hanya untuk mendukung pengalaman kehamilan Mama di aplikasi ini.")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 10)
                    
                        Text("Cara Penggunaan Transeat :")
                            .font(.system(size: 24, weight: .bold))
                        HStack {
                            Image("mascot-guide-1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 107, height: 107)
                            VStack(alignment: .leading, spacing: 2){
                                Text("Bersiaplah di Peron")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text("Pastikan Mama di peron dan aplikasi tetap terbuka.")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .opacity(0)
                            .background(
                                GeometryReader { geometry in
                                    Path { path in
                                        path.move(to: CGPoint(x: 0, y: 0))
                                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                                    }
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 2]))
                                    .foregroundColor(.gray)
                                }
                            )
                        
                        HStack {
                            Image("mascot-guide-2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 107, height: 107)
                            VStack(alignment: .leading, spacing: 2){
                                Text("Kursi sudah diamankan!")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text("Alat di kereta akan berbunyi saat Mama terdeteksi.")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .opacity(0)
                            .background(
                                GeometryReader { geometry in
                                    Path { path in
                                        path.move(to: CGPoint(x: 0, y: 0))
                                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                                    }
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 2]))
                                    .foregroundColor(.gray)
                                }
                            )
                        
                        HStack {
                            Image("mascot-guide-3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 107, height: 107)
                            VStack(alignment: .leading, spacing: 2){
                                Text("Jangan lupa konfirmasi, ya.")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text("Jangan lupa konfirmasi setalah mendapat kursi ya, Mama!")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Spacer()
                }
                .padding(.horizontal, 35)
            }
            
            Divider()
            
            Button {
                goToHome = true
            } label: {
                Text("Saya Mengerti")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(20)
        }
        .navigationTitle("Panduan Penggunaan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToHome) {
            HomeView(expectedDueDate: profiles.first?.expectedDueDate ?? "")
        }
    }
}

#Preview {
    GuidelineView()
}

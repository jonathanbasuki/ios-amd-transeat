import SwiftUI

struct UploadSucces: View {
    var body: some View {
        ZStack(alignment:.topTrailing){
            CardContainer {
                VStack(spacing: 16) {
                    Image("mascot-checked")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 220)
                    
                    Text("Data Anda telah\nTersimpan")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color.hexPalette.cherry500)
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 10)
            }
            .frame(width: 350, height: 440)
        }
    }
}

#Preview {
    UploadSucces()
}

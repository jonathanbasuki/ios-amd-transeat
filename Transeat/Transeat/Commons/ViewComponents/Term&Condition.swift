//
//  Term&Condition.swift
//  Transeat
//
//  Created by Naila Lauza on 09/07/26.
//

import SwiftUI

public struct TermAndConditionView: View {
    
    @Binding private var isChecked : Bool
    @State private var showTermsSheet = false
    @State private var hasOpenedTerms = false

    init(isChecked: Binding<Bool>) {
            self._isChecked = isChecked
        }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .font(.system(size: 24))
                    .foregroundColor(isChecked ? .blue : (hasOpenedTerms ? .gray : Color.gray.opacity(0.4)))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!hasOpenedTerms)
            
            Text("Saya sudah membaca dan setuju atas [ketentuan](custom-action://open-terms) aplikasi")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .tint(Color.hexPalette.cherry500)
                .environment( \.openURL, OpenURLAction { url in
                    if url.absoluteString == "custom-action://open-terms" {
                        hasOpenedTerms = true
                        showTermsSheet = true
                        
                        return .handled
                    }
                    return .discarded
                })
        }
        .padding()
        .sheet(isPresented: $showTermsSheet) {
            TermsAndConditionsDetailView()
        }
    }
}

struct TermsAndConditionsDetailView: View {
    var body: some View {
        NavigationStack {
            Text("Halaman Syarat dan Ketentuan Aplikasi")
                .navigationTitle("Ketentuan")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    TermAndConditionView()
//}

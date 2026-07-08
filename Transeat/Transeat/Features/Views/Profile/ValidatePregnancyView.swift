//
//  ValidatePregnancyView.swift
//  transeatluv
//
//  Created by Gabriella Erlinda on 06/07/26.
//

import SwiftUI

struct ValidatePregnancyView: View {
    @State private var isUSGUploaded = false
    @State private var isMedicationUploaded = false
    @State private var goToData = false
    
    @State private var usgUIImageForOCR: UIImage? = nil
    @State private var medUIImageForOCR: UIImage? = nil
    
    @State private var name: String = "-"
    @State private var age: String = "-"
    @State private var edd: String = "-"
    
    private let OCRManager = OCR()
    
    private var isFormComplete: Bool {
        isUSGUploaded && isMedicationUploaded
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
<<<<<<< Updated upstream
                    UploadCard(title: "USG Proof", isUploaded: $isUSGUploaded, uiImageForOCR: $usgUIImageForOCR)
                    UploadCard(title: "Newest Medication Proof", isUploaded: $isMedicationUploaded, uiImageForOCR: $medUIImageForOCR)
=======
                    UploadCard(title: "Bukti USG", isUploaded: $isUSGUploaded)
                    UploadCard(title: "Surat Dokter Terbaru", isUploaded: $isMedicationUploaded)
>>>>>>> Stashed changes
                }
                .padding(20)
            }
            
            Divider()
            
            Button {
                executeOCRProcessing()
            } label: {
                Text("Konfirmasi")
            }
            .buttonStyle(PrimaryButtonStyle(isDisabled: !isFormComplete))
            .disabled(!isFormComplete)
            .padding(20)
            
        }
        .navigationTitle("Validasi Kehamilan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $goToData) {
            ValidateDataView(name: self.name, age: self.age, hpl: self.edd)
        }
    }
    
    private func executeOCRProcessing() {
        guard let usgImage = usgUIImageForOCR, let medImage = medUIImageForOCR else {
            print("Gagal: Salah satu atau kedua gambar kosong.")
            return
        }
        
        OCRManager.recognizeText(in: usgImage, for: .usgProof) { usgResult in
            self.edd = usgResult.hpl
            
            OCRManager.recognizeText(in: medImage, for: .medProof) { medResult in
                self.name = medResult.name
                self.age = medResult.age
                
                self.goToData = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        ValidatePregnancyView()
    }
}

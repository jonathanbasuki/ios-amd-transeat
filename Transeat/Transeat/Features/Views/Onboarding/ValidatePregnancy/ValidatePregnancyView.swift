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

    private let ocrManager = OCRManager()

    private var isFormComplete: Bool {
        isUSGUploaded && isMedicationUploaded
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    UploadCard(title: "Bukti USG", isUploaded: $isUSGUploaded, uiImageForOCR: $usgUIImageForOCR)
                    UploadCard(title: "Surat Dokter Terbaru", isUploaded: $isMedicationUploaded, uiImageForOCR: $medUIImageForOCR)
                }
                .padding(20)
            }

            Spacer()

            Text("Unggah dokumen kehamilan yang masih berlaku. Pastikan dokumen terlihat jelas agar proses verifikasi berjalan lancar.")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(width: 260)
                .padding(.bottom, 20)

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
            ValidateDataView(
                name: self.name,
                age: self.age,
                hpl: self.edd,
                usgProofData: usgUIImageForOCR?.jpegData(compressionQuality: 0.8),
                medicationProofData: medUIImageForOCR?.jpegData(compressionQuality: 0.8)
            )
        }
    }

    private func executeOCRProcessing() {
        guard let usgImage = usgUIImageForOCR, let medImage = medUIImageForOCR else {
            print("Gagal: Salah satu atau kedua gambar kosong.")
            return
        }

        ocrManager.recognizeText(in: usgImage, for: .usgProof) { usgResult in
            self.edd = usgResult.hpl

            ocrManager.recognizeText(in: medImage, for: .medProof) { medResult in
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

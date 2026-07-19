import SwiftUI
import PhotosUI

struct UploadCard: View {
    let title: String
    @Binding var isUploaded: Bool
    
    @Binding var uiImageForOCR: UIImage?

    @State private var showActionSheet = false
    @State private var showPhotosPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showCamera = false
    @State private var showFileImporter = false
    
    @State private var uploadedImage: Image? = nil
    @State private var uploadedFileURL: URL? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            Button {
                showActionSheet = true
            } label: {
                if isUploaded {
                    uploadedContent
                } else {
                    emptyContent
                }
            }
            .buttonStyle(.plain)
        }
        .confirmationDialog("Pilih file atau ambil foto untuk diunggah.", isPresented: $showActionSheet, titleVisibility: .hidden) {
            Button("Galeri Foto") { showPhotosPicker = true }
            Button("Ambil Foto") { showCamera = true }
            Button("Pilih File") { showFileImporter = true }
            Button("Batal", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { _, newItem in
            if let newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            self.uiImageForOCR = uiImage
                            self.uploadedImage = Image(uiImage: uiImage)
                            simulateUpload()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(isPresented: $showCamera) { uiImage in
                self.uiImageForOCR = uiImage
                self.uploadedImage = Image(uiImage: uiImage)
                simulateUpload()
            }
            .ignoresSafeArea()
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.png, .jpeg, .pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let firstURL = urls.first {
                    self.uploadedFileURL = firstURL
                    simulateUpload()
                }
            case .failure(let error):
                print("Gagal memilih file: \(error.localizedDescription)")
            }
        }
    }

    private func simulateUpload() {
        withAnimation {
            isUploaded = true
        }
    }

    private var emptyContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(.gray)

            Text("Pilih file atau ambil foto untuk diunggah.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text("Format yang didukung: [PNG, JPG, JPEG, PDF](custom-action)")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .tint(Color.hexPalette.cherry500)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .foregroundColor(.gray)
        )
    }

    private var uploadedContent: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .foregroundColor(.gray)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                )

            if let uploadedImage {
                uploadedImage
                    .resizable()
                    .scaledToFill()
            } else if uploadedFileURL != nil {
                VStack(spacing: 8) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                    Text(uploadedFileURL?.lastPathComponent ?? "File Berhasil Diunggah")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            } else {
                Image(systemName: "photo.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.55))
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

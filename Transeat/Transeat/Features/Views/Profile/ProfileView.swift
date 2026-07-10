//
//  ProfileView.swift
//  Transeat
//
//  Created by Gabriella Erlinda on 08/07/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query private var profiles: [UserProfileModel]

    @State private var profileName: String = ""
    @State private var profileAge: String = ""
    @State private var profileEDD: String = ""
    @State private var usgImageData: Data? = nil
    @State private var medicationImageData: Data? = nil
    @State private var showImagePickerForUSG: Bool = false
    @State private var showImagePickerForMedication: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ProfileInputField(label: "Nama", text: $profileName)
                        ProfileInputField(label: "Usia", text: $profileAge)
                        ProfileInputField(label: "Hari Perkiraan Lahir", text: $profileEDD, isDisabled: true)
                    }
                    
                    VStack(spacing: 18) {
                        MedicalProofRow(
                            title: "Bukti USG",
                            fallbackImageName: "mascot-default",
                            imageData: usgImageData,
                            onTap: { showImagePickerForUSG = false }
                        )
                        MedicalProofRow(
                            title: "Surat Dokter Terbaru",
                            fallbackImageName: "mascot-default",
                            imageData: medicationImageData,
                            onTap: { showImagePickerForMedication = false }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            Spacer()

            saveProfileButton
        }
        .navigationTitle("Profil Mama")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadProfileFromSwiftData()
        }
        .sheet(isPresented: $showImagePickerForUSG) {
            ImagePicker(selectedData: $usgImageData)
        }
        .sheet(isPresented: $showImagePickerForMedication) {
            ImagePicker(selectedData: $medicationImageData)
        }
    }

    // MARK: - SwiftData Operations

    private func loadProfileFromSwiftData() {
        if let existingProfile = profiles.first {
            profileName = existingProfile.name
            profileAge = String(existingProfile.age)
            profileEDD = existingProfile.expectedDueDate
            usgImageData = existingProfile.usgProofData
            medicationImageData = existingProfile.medicationProofData
        }
    }

    private func saveProfileToSwiftData() {
        if let existingProfile = profiles.first {
            // Update existing profile
            existingProfile.name = profileName
            existingProfile.age = Int(profileAge) ?? 0
            existingProfile.expectedDueDate = profileEDD
            existingProfile.usgProofData = usgImageData
            existingProfile.medicationProofData = medicationImageData
        } else {
            // Create new profile
            let newProfile = UserProfileModel(
                name: profileName,
                age: Int(profileAge) ?? 0,
                expectedDueDate: profileEDD,
                usgProofData: usgImageData,
                medicationProofData: medicationImageData
            )
            modelContext.insert(newProfile)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }
}

// MARK: - Interface View Subcomponents Layouts
extension ProfileView {
    private var saveProfileButton: some View {
        Button(action: {
            saveProfileToSwiftData()
            dismiss()
        }) {
            Text("Simpan Perubahan")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.hexPalette.cherry500)
                .cornerRadius(25)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Image Picker (UIKit Bridge)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedData = image.jpegData(compressionQuality: 0.8)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .modelContainer(for: UserProfileModel.self)
}

//
//  CameraPicker.swift
//  Transeat
//
//  Created by Naila Lauza on 07/07/26.
//

import SwiftUI
import UIKit

// MARK: - CameraPicker UIViewControllerRepresentable

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onImagePicked: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // Mengatur sumber pengambilan media ke kamera bawaan
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.mediaTypes = ["public.image"] // Memastikan hanya gambar yang bisa diambil
        } else {
            // Menangani kasus di mana kamera tidak tersedia (misalnya di simulator)
            print("Kamera tidak tersedia pada perangkat ini.")
            // Sebagai fallback, bisa menggunakan photoLibrary atau memberikan peringatan kepada pengguna
            // Dalam contoh ini, kita tetap membiarkan sourceType default (photoLibrary) atau menangani error secara spesifik
        }
        
        picker.delegate = context.coordinator
        picker.allowsEditing = false // Atur ke true jika ingin mengizinkan pengeditan setelah pengambilan foto
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            } else if let editedImage = info[.editedImage] as? UIImage {
                // Gunakan ini jika allowsEditing diatur ke true
                parent.onImagePicked(editedImage)
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

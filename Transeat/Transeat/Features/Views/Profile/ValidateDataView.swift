import SwiftUI
import SwiftData

struct ValidateDataView: View {
    @State private var isUSGUploaded = false
    @State private var isMedicationUploaded = false
    @State private var goToData = false
    
    @State private var isTermsAccepted = false
    
    @State private var name: String
    @State private var age: String
    @State private var hpl: String
    
    @State private var uploadStatus: UploadStatus
    @State private var bannerMessage: String
    
    @State private var goToHome = false
    
    private enum Field {
        case name, age
    }
    
    @FocusState private var focusedField: Field?
    
    init(name: String, age: String, hpl: String) {
        _name = State(initialValue: name)
        _age = State(initialValue: age)
        _hpl = State(initialValue: hpl)
        
        if hpl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            _uploadStatus = State(initialValue: .error)
            _bannerMessage = State(initialValue: "Terjadi Kesalahan. Coba upload ulang!")
        } else {
            _uploadStatus = State(initialValue: .success)
            _bannerMessage = State(initialValue: "File Anda berhasil di upload!")
        }
    }
    
    @State private var saveError: String?
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Formulir ini akan terisi otomatis berdasarkan dokumen yang diunggah, namun Anda tetap dapat mengeditnya")
                        .font(.system(size: 13))
                        .foregroundColor(Color.hexPalette.darkgray)
                    
                    NotificationBanner(type: uploadStatus, message: bannerMessage)
                    
                    labeledField(title: "Nama", text: $name)
                        .focused($focusedField, equals: .name)
                    
                    labeledField(title: "Usia", text: $age, keyboardType: .numberPad)
                        .focused($focusedField, equals: .age)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hari Perkiraan Lahir")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text(hpl.isEmpty ? "-" : hpl)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(Color.hexPalette.lightgray.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Text("Tanggal perkiraan lahir ini akan menentukan masa berlaku aplikasi.")
                            .font(.system(size: 13))
                            .foregroundColor(Color.hexPalette.darkgray)
                    }
                    
                    if let saveError {
                        Text(saveError)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                    }
                }
                .padding(20)
            }
            .onTapGesture {
                focusedField = nil
            }
            
            TermAndConditionView(isChecked: $isTermsAccepted)
            
            Divider()
            
            Button {
                focusedField = nil
                saveProfileAndContinue()
            } label: {
                Text("Konfirmasi")
            }
            .buttonStyle(PrimaryButtonStyle(isDisabled: !isTermsAccepted))
            .disabled(!isTermsAccepted)
            .padding(20)
            
        }
        .onTapGesture {
            focusedField = nil
        }
        .navigationTitle("Validasi Kehamilan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $goToHome) {
            HomeView()
        }
    }
    
    @ViewBuilder
    private func labeledField(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            TextField(title, text: text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.hexPalette.lightgray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func saveProfileAndContinue() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            saveError = "Nama tidak boleh kosong"
            return
        }
        guard let ageValue = Int(age), ageValue > 0 else {
            saveError = "Usia harus berupa angka yang valid"
            return
        }
        guard !hpl.trimmingCharacters(in: .whitespaces).isEmpty else {
            saveError = "Hari perkiraan lahir tidak boleh kosong"
            return
        }
        
        let profile = UserProfile(
            name: name,
            age: ageValue,
            expectedDueDate: hpl
        )
        modelContext.insert(profile)
        
        do {
            try modelContext.save()
            saveError = nil
            goToHome = true
        } catch {
            saveError = "Gagal menyimpan data: \(error.localizedDescription)"
            print("[ValidateDataView] SwiftData save failed: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        ValidateDataView(name: "Kartini", age: "36", hpl: "01-02-2026")
    }
    .modelContainer(for: UserProfile.self, inMemory: true)
}

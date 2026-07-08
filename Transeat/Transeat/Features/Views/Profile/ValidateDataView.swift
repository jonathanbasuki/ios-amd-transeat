import SwiftUI
import SwiftData

struct ValidateDataView: View {
<<<<<<< Updated upstream
    // the extracted USG / medication proof documents.
    @State private var name: String
    @State private var age: String
    @State private var hpl: String

    @State private var goToHome = false
    
    init(name: String, age: String, hpl: String) {
            _name = State(initialValue: name)
            _age = State(initialValue: age)
            _hpl = State(initialValue: hpl)
        }
=======
    @State private var name: String = "Kartini"
    @State private var age: String = "36"
    @State private var edd: String = "12/04/2027"

    @State private var goToHome = false
    @State private var saveError: String?

    @Environment(\.modelContext) private var modelContext
>>>>>>> Stashed changes

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Formulir ini akan terisi otomatis berdasarkan dokumen yang diunggah.")
                        .font(.system(size: 13))
                        .foregroundColor(Color.hexPalette.darkgray)

                    labeledField(title: "Nama", text: $name)
                    labeledField(title: "Usia", text: $age, keyboardType: .numberPad)

                    VStack(alignment: .leading, spacing: 8) {
<<<<<<< Updated upstream
                        labeledField(title: "Expected Due Date (EDD)", text: $hpl)
                        Text("This due date will determine the expiration date of the app")
=======
                        labeledField(title: "Hari Perkiraan Lahir", text: $edd)
                        Text("Tanggal perkiraan lahir ini akan menentukan masa berlaku aplikasi.")
>>>>>>> Stashed changes
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

            Divider()

            Button {
                saveProfileAndContinue()
            } label: {
                Text("Konfirmasi")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(20)
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
        guard !edd.trimmingCharacters(in: .whitespaces).isEmpty else {
            saveError = "Hari perkiraan lahir tidak boleh kosong"
            return
        }

        let profile = UserProfile(
            name: name,
            age: ageValue,
            expectedDueDate: edd
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

<<<<<<< Updated upstream
//#Preview {
//    NavigationStack {
//        ValidateDataView(name: self.name, age: self.age, hpl: self.edd)
//    }
//}
=======
#Preview {
    NavigationStack {
        ValidateDataView()
    }
    .modelContainer(for: UserProfile.self, inMemory: true)
}
>>>>>>> Stashed changes

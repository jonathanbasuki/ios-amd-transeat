import SwiftUI

struct TermsAndConditionsDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hasAgreed: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Dokumen ini dibuat dengan memperhatikan aspek perlindungan data medis (privasi) agar pengguna merasa aman dan aplikasi Anda mematuhi standar hukum yang berlaku (seperti UU Pelindungan Data Pribadi/UU PDP di Indonesia).")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                            .padding(.bottom, 8)
                        
                        Divider()
                        
                        Text("SYARAT DAN KETENTUAN PENGGUNAAN APLIKASI TRANSEAT")
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        
                        Text("Pembaruan Terakhir: 14 Juli 2026")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Selamat datang di Transeat. Hubungan Anda dengan Transeat diatur oleh Syarat dan Ketentuan ini. Mohon luangkan waktu Anda untuk membaca Ketentuan ini secara saksama sebelum menggunakan aplikasi kami.\n\nDengan mengunduh, mendaftar, atau menggunakan Aplikasi, Anda menyatakan bahwa Anda telah membaca, memahami, dan menyetujui untuk terikat oleh Ketentuan ini serta Kebijakan Privasi kami.")
                            .font(.body)
                        
                        Group {
                            Text("1. DEFINISI & LAYANAN")
                                .font(.headline)
                                .bold()
                            
                            Text("**Aplikasi:** Merujuk pada aplikasi mobile Transeat yang menyediakan layanan untuk memberikan pengumuman dan tanda visual bahwa ada wanita hamil di dalam kendaraan yang membutuhkan tempat duduk.")
                            Text("**Pengguna:** Ibu Hamil yang mengunduh dan menggunakan Aplikasi.")
                            Text("**Data Medis Sensitif:** Data kesehatan pribadi Pengguna, termasuk namun tidak terbatas pada foto/berkas hasil Ultrasonografi (USG), surat keterangan dokter, dan riwayat medis.")
                        }
                        .font(.body)
                        
                        Group {
                            Text("2. PENGUMPULAN DAN PENGGUNAAN DATA PRIBADI & MEDIS")
                                .font(.headline)
                                .bold()
                            
                            Text("Untuk memberikan layanan yang optimal, Aplikasi memerlukan data pribadi dan medis Anda.")
                            Text("**Jenis Data yang Diperlukan:** Anda akan diminta untuk mengunggah dokumen resmi seperti Hasil USG dan Surat Dokter yang mencantumkan nama lengkap, tanggal lahir, usia kehamilan, dan kondisi medis Anda.")
                            Text("**Tujuan Pengumpulan:** Data ini digunakan hanya untuk memvalidasi usia kehamilan dan memvalidasi data diri.")
                            Text("**Persetujuan (Consent):** Dengan mengunggah dokumen-dokumen tersebut, Anda memberikan persetujuan eksplisit kepada Aplikasi untuk memproses dan menyimpan data medis Anda sesuai dengan Kebijakan Privasi kami.")
                        }
                        .font(.body)
                        
                        Group {
                            Text("3. KEAMANAN DAN PERLINDUNGAN DATA")
                                .font(.headline)
                                .bold()
                            
                            Text("Kami memahami bahwa data medis bersifat sangat sensitif. Kami berkomitmen untuk menjaga keamanan data Anda dengan standar terbaik:")
                            Text("• **Enkripsi Data:** Semua data pribadi dan dokumen medis yang Anda unggah akan dikirim dan disimpan menggunakan teknologi enkripsi aman (misalnya: SSL/TLS dan enkripsi pada penyimpanan data).")
                            Text("• **Pembatasan Akses:** Dokumen hasil USG dan Surat Dokter Anda hanya dapat diakses oleh pihak yang berwenang (seperti tenaga medis yang melayani Anda atau sistem otomatis pendukung layanan) dan tidak akan dibuka untuk umum.")
                            Text("• **Kepatuhan Hukum:** Kami mengelola data Anda sesuai dengan peraturan perundang-undangan perlindungan data pribadi yang berlaku di Indonesia (UU PDP).")
                        }
                        .font(.body)
                        
                        Group {
                            Text("4. PENYANGKALAN MEDIS (MEDICAL DISCLAIMER)")
                                .font(.headline)
                                .bold()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("⚠️ **PENTING:** Aplikasi ini adalah alat bantu informasi dan pemantauan mandiri. **TRANSEAT BUKAN** pengganti saran, diagnosis, atau perawatan medis profesional. Informasi dari hasil interpretasi aplikasi terhadap data USG atau surat dokter Anda tidak boleh digunakan sebagai satu-satunya dasar tindakan medis. Selalu konsultasikan kondisi kehamilan Anda secara langsung dengan Dokter Spesialis Kebidanan dan Kandungan (Obgyn) atau Bidan.")
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.15))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.yellow, lineWidth: 1)
                            )
                        }
                        .font(.body)
                        
                        Group {
                            Text("5. TANGGUNG JAWAB PENGGUNA")
                                .font(.headline)
                                .bold()
                            
                            Text("**Keaslian Data:** Anda menjamin bahwa semua data, hasil USG, dan surat dokter yang Anda unggah adalah asli, akurat, terkini, dan milik Anda sendiri (atau Anda memiliki hak hukum penuh untuk mengunggahnya).")
                            Text("**Penyalahgunaan Data:** Pengunggahan dokumen palsu, milik orang lain tanpa izin, atau dokumen yang dimanipulasi dapat mengakibatkan pemblokiran akun secara permanen dan/atau tindakan hukum.")
                        }
                        .font(.body)
                        
                        Group {
                            Text("6. HAK PENGGUNA ATAS DATA")
                                .font(.headline)
                                .bold()
                            
                            Text("Sesuai dengan hak privasi Anda, Anda berhak untuk:")
                            Text("• Melihat dan memperbarui data pribadi Anda di dalam Aplikasi.")
                            Text("• Meminta penghapusan akun beserta seluruh dokumen medis (USG dan Surat Dokter) yang pernah diunggah melalui fitur hapus akun atau menghubungi Layanan Pelanggan kami.")
                        }
                        .font(.body)
                        
                        Group {
                            Text("7. PERUBAHAN SYARAT DAN KETENTUAN")
                                .font(.headline)
                                .bold()
                            
                            Text("Kami dapat memperbarui Syarat dan Ketentuan ini dari waktu ke waktu. Jika ada perubahan signifikan terkait cara kami mengelola data sensitif Anda, kami akan memberikan notifikasi melalui Aplikasi atau email terdaftar. Penggunaan Aplikasi yang berkelanjutan setelah perubahan tersebut berarti Anda menerima ketentuan yang baru.")
                        }
                        .font(.body)
                        
                    }
                    .padding()
                }
                
                // Footer
                VStack(spacing: 0) {
                    Divider()
                    
                    Toggle(isOn: $hasAgreed) {
                        Text("Saya telah membaca dan menyetujui seluruh Syarat & Ketentuan di atas.")
                            .font(.system(size: 14))
                    }
                    .toggleStyle(CheckboxToggle())
                    .padding(.vertical, 20)
                    .onChange(of: hasAgreed) { _, newValue in
                        if newValue {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Syarat & Ketentuan")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

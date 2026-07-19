import SwiftUI
import Vision
import Foundation
import PhotosUI

enum DocumentSource {
    case usgProof
    case medProof
}

struct OCRResult {
    var name: String = ""
    var age: String = ""
    var hpl: String = ""
    var status: String = "Success"
}

struct OCRManager {
    func recognizeText(in image: UIImage, for source: DocumentSource, completion: @escaping (OCRResult) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(OCRResult())
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error: \(error)")
                completion(OCRResult())
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(OCRResult())
                return
            }
            
            let alltextlines = observations.compactMap({ $0.topCandidates(1).first?.string })
            
            let result = extractSpecificInformation(from: alltextlines, source: source)
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    private func extractSpecificInformation(from textLines: [String], source: DocumentSource) -> OCRResult {
        let datePattern = #"\b\d{2}[.\/-]\d{2}[.\/-]\d{4}\b"#
        var result = OCRResult()
        
        switch source {
        case .usgProof:
            var eddFound = false
                    var detectedRawDate: String? = nil
                   
                    for text in textLines {
                        let textLower = text.lowercased()
                        if textLower.contains("hpl") || textLower.contains("edd") || textLower.contains("perkiraan") {
                            if let range = text.range(of: datePattern, options: .regularExpression) {
                                detectedRawDate = String(text[range])
                                eddFound = true
                                break
                            }
                        }
                    }
                    
                    if !eddFound {
                        for text in textLines {
                            if let range = text.range(of: datePattern, options: .regularExpression) {
                                detectedRawDate = String(text[range])
                                break
                            }
                        }
                    }
                    
                    if let rawDate = detectedRawDate {
                        let formattedDate = formatToStandardDate(rawDate)
                        
                        if isValidHPL(formattedDate) {
                            result.hpl = formattedDate
                            result.status = "Success"
                        } else {
                            result.hpl = ""
                            result.status = "Error: HPL tidak valid (Harus hari ini hingga 9 bulan ke depan)"
                        }
                    } else {
                        result.status = "Error: Tanggal tidak ditemukan"
                    }
            
        case .medProof:
            for (index, text) in textLines.enumerated() {
                let textLower = text.lowercased()
                
                if textLower.contains("nama") || textLower.contains("name") {
                    let components = text.components(separatedBy: ":")
                    var candidateName = ""
                    
                    if components.count > 1 {
                        candidateName = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    
                    if candidateName.isEmpty || candidateName == "" {
                        let nextIndex = index + 1
                        if nextIndex < textLines.count {
                            candidateName = textLines[nextIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                    
                    result.name = candidateName.replacingOccurrences(of: ":", with: "", options: .caseInsensitive)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if textLower.contains("age") || textLower.contains("umur") || textLower.contains("tahun") || textLower.contains("years") {
                    let components = text.components(separatedBy: ":")
                    var candidateAge = ""
                    
                    if components.count > 1 {
                        candidateAge = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    
                    if candidateAge.isEmpty || candidateAge == "" {
                        let nextIndex = index + 1
                        if nextIndex < textLines.count {
                            candidateAge = textLines[nextIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                    let rawAge = candidateAge.replacingOccurrences(of: ":", with: "", options: .caseInsensitive)
                                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    result.age = String(rawAge.filter { $0.isNumber })
                }
            }
        }
        return result
    }
}

private func formatToStandardDate(_ rawDate: String) -> String {
    let cleanDate = rawDate
        .replacingOccurrences(of: ".", with: "/")
        .replacingOccurrences(of: "-", with: "/")
    return cleanDate
}

private func isValidHPL(_ dateString: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    guard let hplDate = dateFormatter.date(from: dateString) else {
        return false
    }
    
    let calendar = Calendar.current
    let now = Date()

    let startOfToday = calendar.startOfDay(for: now)
   
    guard let maxHPLDate = calendar.date(byAdding: .month, value: 9, to: startOfToday) else {
        return false
    }

    return hplDate >= startOfToday && hplDate <= maxHPLDate
}

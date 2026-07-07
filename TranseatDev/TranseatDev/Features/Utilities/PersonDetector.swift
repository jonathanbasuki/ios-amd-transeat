//
//  PersonDetector.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 02/07/26.
//

import Combine
import Foundation
import Vision
import CoreGraphics

class PersonDetector: ObservableObject {
    @Published var detectedPersons: [DetectedPerson] = []

    private var isProcessing = false // avoid overlapping requests on slow frames

    private let maxBoxes = 6

    func detect(in pixelBuffer: CVPixelBuffer) {
        guard !isProcessing else { return }
        isProcessing = true

        let request = VNDetectHumanRectanglesRequest { [weak self] request, error in
            self?.handleResults(request.results as? [VNHumanObservation])
            self?.isProcessing = false
        }

        // Use the newer revision so we can detect full bodies, not just
        // upper-body/torso (the old default behavior).
        request.revision = VNDetectHumanRectanglesRequestRevision2
        request.upperBodyOnly = false
        // If people are frequently seated with their lower body blocked
        // (e.g. by a seat or desk) and you're getting missed detections,
        // try flipping this to `true` — upper-body-only tends to be more
        // reliable when only the top half of a person is visible.

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("Vision request failed: \(error)")
            isProcessing = false
        }
    }

    private func handleResults(_ results: [VNHumanObservation]?) {
        guard let results else { return }

        let persons = results
            .sorted { $0.confidence > $1.confidence }
            .prefix(maxBoxes)                                      // rule: max 6 boxes
            .map { observation -> DetectedPerson in
                // Same flip as before: Vision's origin is bottom-left,
                // SwiftUI's is top-left.
                let flipped = CGRect(
                    x: observation.boundingBox.minX,
                    y: 1 - observation.boundingBox.minY - observation.boundingBox.height,
                    width: observation.boundingBox.width,
                    height: observation.boundingBox.height
                )
                return DetectedPerson(boundingBox: flipped, confidence: Double(observation.confidence))
            }

        DispatchQueue.main.async {
            self.detectedPersons = Array(persons)
        }
    }
}

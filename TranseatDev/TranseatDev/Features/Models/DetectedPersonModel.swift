//
//  DetectedPersonModel.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 07/07/26.
//

import Foundation
import CoreGraphics


struct DetectedPerson: Identifiable {
    let id = UUID()
    let boundingBox: CGRect
    let confidence: Double
}

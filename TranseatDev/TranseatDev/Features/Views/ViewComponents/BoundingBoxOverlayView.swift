//
//  BoundingBoxOverlayView.swift
//  TranseatDev
//
//  Created by Brandon Nathan Haliman on 07/07/26.
//


import SwiftUI

struct BoundingBoxOverlayView: View {
    let persons: [DetectedPerson]

    var body: some View {
        GeometryReader { geo in
            ForEach(persons) { person in
                let rect = CGRect(
                    x: person.boundingBox.minX * geo.size.width,
                    y: person.boundingBox.minY * geo.size.height,
                    width: person.boundingBox.width * geo.size.width,
                    height: person.boundingBox.height * geo.size.height
                )
                Rectangle()
                    .strokeBorder(Color.green, lineWidth: 2)
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
            }
        }
    }
}

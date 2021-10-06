//
//  CGPath+Extensions.swift
//  
//
//  Created by Lisnic Victor on 22.09.2021.
//

import Foundation
import CoreGraphics

public extension CGPath {
    func resized(to rect: CGRect) -> CGPath {
        let boundingBox = self.boundingBox
        let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
        let viewAspectRatio = rect.width / rect.height
        let scaleFactor = boundingBoxAspectRatio > viewAspectRatio ?
            rect.width / boundingBox.width :
            rect.height / boundingBox.height

        let scaledSize = boundingBox.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let centerOffset = CGSize(
            width: (rect.width - scaledSize.width) / (scaleFactor * 2),
            height: (rect.height - scaledSize.height) / (scaleFactor * 2)
        )

        var transform = CGAffineTransform.identity
            .scaledBy(x: scaleFactor, y: scaleFactor)
            .translatedBy(x: -boundingBox.minX + centerOffset.width, y: -boundingBox.minY + centerOffset.height)

        return copy(using: &transform)!
    }
}


import MapKit
public extension CGPath {
    static func multiPolyLine(coordinates: [[CLLocationCoordinate2D]]) -> CGPath? {
        let renderer = MKMultiPolylineRenderer(
            multiPolyline: MKMultiPolyline(coordinates.map { MKPolyline(coordinates: $0, count: $0.count) })
        )

        renderer.createPath()
        let path = renderer.path

        if path?.boundingBox == .zero || path?.boundingBox.origin.x == .infinity {
            return nil
        }

        return path
    }
}

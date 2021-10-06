import CoreGraphics
import SwiftUI

public enum TrigHelpers {
    public static func position(_ radius: Double, angle: Double) -> CGPoint {
        CGPoint(x: radius * cos(angle),
                y: radius * sin(angle))
    }
    
    public static func angle(position: CGPoint) -> Angle {
        Angle(radians: Double(atan2(position.x, position.y)))
    }
}


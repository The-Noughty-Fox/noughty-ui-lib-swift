import SwiftUI

public struct ColorOverlay {
    public let color: Color
    public let blendMode: BlendMode
    public let oacity: Double
    
    public init(
        color: Color,
        blendMode: BlendMode,
        oacity: Double
    ) {
        self.color = color
        self.blendMode = blendMode
        self.oacity = oacity
    }
}

extension View {
    public func colorOverlay(_ overlay: ColorOverlay) -> some View {
        self.overlay(
                overlay.color
                    .blendMode(overlay.blendMode)
                    .opacity(overlay.oacity)
            )
    }
}

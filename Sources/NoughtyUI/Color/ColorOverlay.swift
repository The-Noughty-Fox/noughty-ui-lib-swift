import SwiftUI

public struct ColorOverlay {
    public let color: Color
    public let blendMode: BlendMode
    public let oacity: Double
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

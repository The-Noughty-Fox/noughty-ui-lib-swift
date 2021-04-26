import SwiftUI

public struct ThickButtonStyle: ButtonStyle {
    let foregroundColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    public init(foregroundColor: Color,
                backgroundColor: Color,
                cornerRadius: CGFloat = 8) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(CGSize(width: configuration.isPressed ? 0.95 : 1.0 ,
                                height: configuration.isPressed ? 0.95 : 1.0))
    }
}

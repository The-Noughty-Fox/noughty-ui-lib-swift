import SwiftUI

public struct Border: ViewModifier {
    public enum RelationToContent {
        case under
        case over
    }
    
    public let relationToContent: RelationToContent
    public let cornerRadius: CGFloat
    public let color: Color
    public let lineWidth: CGFloat
    
    public init(
        relationToContent: RelationToContent,
        cornerRadius: CGFloat,
        color: Color,
        lineWidth: CGFloat
    ){
        self.relationToContent = relationToContent
        self.cornerRadius = cornerRadius
        self.color = color
        self.lineWidth = lineWidth
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        switch relationToContent {
        case .under:
            content.background(border)
        case .over:
            content.overlay(border)
        }
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(color, lineWidth: 1)
    }
}

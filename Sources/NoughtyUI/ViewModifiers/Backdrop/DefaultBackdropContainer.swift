import SwiftUI

// Default backdrop content wrapper
// Provides background and chevron
// Important: This container is not sliding from the bottom, it changes its height in response to stage and drag offset.
public struct DefaultBackdropContainer: ViewModifier {
    public let config: BackDropContentConfig
    public let backgroundColor: Color
    public let cornerRadius: CGFloat
    public let showChevron: Bool
    
    public let chevronColor: (BackdropStage) -> Color
    
    public init(config: BackDropContentConfig,
                backgroundColor: Color,
                cornerRadius: CGFloat,
                showChevron: Bool,
                chevronColor: @escaping (BackdropStage) -> Color) {
        self.config = config
        self.showChevron = showChevron
        self.backgroundColor = backgroundColor
        self.chevronColor = chevronColor
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        VStack {
            if showChevron {
                chevron
            }
            content
                // content wrapper with apropriate size and flexibility
                .frame(maxWidth: .infinity)
                .frame(height: config.height)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
        // a proposed size wrapper with bottom alignment
        .frame(maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottom)
    }
    
    private var chevron: some View {
        Capsule()
            .fill(chevronColor(config.stage))
            .frame(width: 30, height: 5)
            .offset(x: 0, y: config.stage == .full ? 20 : 0)
            .zIndex(10)
    }
}

public extension View {
    func defaultBackdropContainer(config: BackDropContentConfig,
                                  backgroundColor: Color = .white,
                                  cornerRadius: CGFloat = 8,
                                  showChevron: Bool = true,
                                  chevronColor: @escaping (BackdropStage) -> Color = { _ in .white }) -> some View {
        modifier(DefaultBackdropContainer(config: config, backgroundColor: backgroundColor, cornerRadius: cornerRadius, showChevron: showChevron, chevronColor: chevronColor))
    }
}

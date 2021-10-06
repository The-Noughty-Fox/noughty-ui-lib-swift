import SwiftUI

// Default backdrop content wrapper
// Provides background and chevron
// Important: This container is not sliding from the bottom, it changes its height in response to stage and drag offset.
public struct DefaultBackdropContainer: ViewModifier {
    
    public enum DragBehaviour {
        case scaling
        case offset
    }
    
    public let config: BackDropContentConfig
    public let backgroundColor: Color
    public let cornerRadius: CGFloat
    public let showChevron: Bool
    public let dragBehaviour: DragBehaviour
    
    public let chevronColor: (BackdropStage) -> Color
    
    public init(
        config: BackDropContentConfig,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 24,
        dragBehaviour: DragBehaviour = .offset,
        showChevron: Bool = true,
        chevronColor: @escaping (BackdropStage) -> Color
    ) {
        self.config = config
        self.showChevron = showChevron
        self.backgroundColor = backgroundColor
        self.chevronColor = chevronColor
        self.cornerRadius = cornerRadius
        self.dragBehaviour = dragBehaviour
    }
    
    @State var contentSize: CGSize = .zero
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        switch dragBehaviour {
        case .offset:
            offset(content)
        case .scaling:
            scaling(content)
        }
    }
    
    private func scaling(_ content: Content) -> some View {
        VStack {
            if showChevron {
                chevron
            }
            content
                // Content wrapper with proposed size width
                .frame(maxWidth: .infinity)
                // Content wrapper with locked height
                .frame(height: config.height)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom // this is used to align scaling container to the bottom and scale it up
        )
    }
    
    private func offset(_ content: Content) -> some View {
        VStack {
            if showChevron {
                chevron
            }
            content
                // Content wrapper with proposed size width
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
        // Wrapper for the VStack the size of the proposed size, which will be sliding (applying an offset)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top // this is used to align the content to the top inside the moving container
        )
        .offset(x: 0, y: config.offset)
        // Wrapper for the Content + Offset, the size of the proposed size, inside which the offset of the frame above will happen
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top // this is used to align moving container to the top and apply offset
        )
    }
    
    private var chevron: some View {
        Capsule()
            .fill(chevronColor(config.stage))
            .frame(width: 30, height: 5)
            .offset(
                x: 0,
                y: config.stage == .full ? 20 : 0
            )
            .zIndex(10)
    }
}

public extension View {
    func defaultBackdropContainer(
        config: BackDropContentConfig,
        backgroundColor: Color = .white,
        dragBehaviour: DefaultBackdropContainer.DragBehaviour = .offset,
        cornerRadius: CGFloat = 8,
        showChevron: Bool = true,
        chevronColor: @escaping (BackdropStage) -> Color = { _ in .white }
    ) -> some View {
        modifier(
            DefaultBackdropContainer(
                config: config,
                backgroundColor: backgroundColor,
                cornerRadius: cornerRadius,
                dragBehaviour: dragBehaviour,
                showChevron: showChevron,
                chevronColor: chevronColor
            )
        )
    }
}

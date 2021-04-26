import SwiftUI

extension View {
    @ViewBuilder
    public func hidden(_ isHidden: Bool) -> some View {
        if isHidden { hidden() } else { self }
    }
}

extension View {    
    public func border(color: Color,
                       corderRadius: CGFloat,
                       relationToContent: Border.RelationToContent,
                       lineWidth: CGFloat) -> some View {
        self.modifier(Border(relationToContent: relationToContent,
                             cornerRadius: corderRadius,
                             color: color,
                             lineWidth: lineWidth))
    }
}

extension View {
    public func swipe<ActionView: View>(action: @escaping () -> (),
                                        swipeLockLimit: CGFloat = 100,
                                        swipeActionLimit: CGFloat = 150,
                                        actionView: @escaping (DeleteViewConfig) -> ActionView) -> some View {
        modifier(
            SwipeToDeleteModifier(onDelete: action,
                                  deleteView: actionView,
                                  limit: swipeLockLimit,
                                  actionLimit: swipeActionLimit)
        )
    }
    
    public func swipeToDelete(action: @escaping () -> (),
                              swipeLockLimit: CGFloat = 100,
                              swipeActionLimit: CGFloat = 150,
                              deleteButtonBackgroundColor: Color,
                              deleteButtonForegroundColor: Color
                              ) -> some View {
        modifier(
            SwipeToDeleteModifier(onDelete: action,
                                  deleteView: { deleteView($0, foregroundColor: deleteButtonForegroundColor, backgroundColor: deleteButtonBackgroundColor) },
                                  limit: swipeLockLimit,
                                  actionLimit: swipeActionLimit)
        )
    }
    
    private func deleteView(_ config: DeleteViewConfig,
                            foregroundColor: Color,
                            backgroundColor: Color) -> some View {
        Text("Delete")
            .padding()
            .foregroundColor(foregroundColor)
            .frame(maxHeight: .infinity)
            .frame(width: config.swipeStage == .commit ? config.availableWidth : nil, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(config.swipeStage == .commit ? 0 : 8)
            .padding(.horizontal, config.swipeStage == .commit ? 0 : 8)
            .scaleEffect(config.progress)
    }
}

import SwiftUI

extension View {
    @ViewBuilder
    public func hidden(_ isHidden: Bool) -> some View {
        if isHidden { hidden() } else { self }
    }
}

extension View {
    public func border(
        color: Color,
        corderRadius: CGFloat,
        relationToContent: Border.RelationToContent,
        lineWidth: CGFloat
    ) -> some View {
        self.modifier(
            Border(
                relationToContent: relationToContent,
                cornerRadius: corderRadius,
                color: color,
                lineWidth: lineWidth
            )
        )
    }
}

extension View {
    public func onSwipeActions<Action: Hashable, ActionView: View>(
        actions: [Action],
        limit: CGFloat = 150,
        actionLimit: CGFloat = 150,
        @ViewBuilder container: @escaping (Action, SwipeActionConfig) -> ActionView
    ) -> some View {
        self.modifier(
            SwipeActionModifier(
                swipeActions: actions,
                actionLimit: actionLimit,
                container: container
            )
        )
    }
}

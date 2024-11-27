import SwiftUI
import Combine

public struct SizeKey: PreferenceKey {
    public static let defaultValue: CGRect? = nil
    public static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = value ?? nextValue()
    }
}

public struct SafeAreaInsetsKey: PreferenceKey {
    public static let defaultValue: EdgeInsets? = nil
    public static func reduce(value: inout EdgeInsets?, nextValue: () -> EdgeInsets?) {
        value = value ?? nextValue()
    }
}

public struct SizeObserver<T>: ViewModifier {
    @Binding public var size: T
    let coordinateSpace: CoordinateSpace
    let transform: (CGRect) -> T

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { pr in
                    Color.clear
                        .preference(key: SizeKey.self, value: pr.frame(in: coordinateSpace))
                        .preference(key: SafeAreaInsetsKey.self, value: pr.safeAreaInsets)
                }.onPreferenceChange(SizeKey.self, perform: { size in
                    self.size = transform(size ?? .zero)
                })
            )
    }
}

extension View {
    public func observeSize(space: CoordinateSpace = .global, _ binding: Binding<CGRect>) -> some View {
        modifier(SizeObserver(size: binding, coordinateSpace: space, transform: {$0}))
    }

    public func observeSize(space: CoordinateSpace = .global, _ binding: Binding<CGSize>) -> some View {
        modifier(SizeObserver(size: binding, coordinateSpace: space, transform: {$0.size}))
    }
}


import SwiftUI
import Combine

public struct SizeKey: PreferenceKey {
    public static let defaultValue: CGSize? = nil
    public static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

public struct SafeAreaInsetsKey: PreferenceKey {
    public static let defaultValue: EdgeInsets? = nil
    public static func reduce(value: inout EdgeInsets?, nextValue: () -> EdgeInsets?) {
        value = value ?? nextValue()
    }
}

public struct SizeObserver: ViewModifier {
    @Binding public var size: CGSize
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { pr in
                    Color.clear
                        .preference(key: SizeKey.self, value: pr.size)
                        .preference(key: SafeAreaInsetsKey.self, value: pr.safeAreaInsets)
                }.onPreferenceChange(SizeKey.self, perform: { size in
                    self.size = size ?? .zero
                })
            )
    }
}

extension View {
    public func observeSize(_ binding: Binding<CGSize>) -> some View {
        modifier(SizeObserver(size: binding))
    }
}

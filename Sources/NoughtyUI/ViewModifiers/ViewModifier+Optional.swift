import SwiftUI

extension View {
    @ViewBuilder
    public func optional<Content: View, T>(value: T?, modifier: ((Self, T) -> Content) ) -> some View {
        if let value = value {
            modifier(self, value)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func optional<Content: View>(modifier: ((Self) -> Content)? ) -> some View {
        if let modifier = modifier {
            modifier(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func optional<Content: View>(applied: Bool, modifier: (Self) -> Content ) -> some View {
        if applied {
            modifier(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func optional<T: ViewModifier>(applied: Bool, modifier: T) -> some View {
        if applied {
            self.modifier(modifier)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func optional<T: ViewModifier>(modifier: T?) -> some View {
        if let modifier = modifier {
            self.modifier(modifier)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func optional<T: ViewModifier, U>(value: U?, modifier: T) -> some View {
        if let _ = value {
            self.modifier(modifier)
        } else {
            self
        }
    }
}


import SwiftUI

public extension View {
    func expandedText(isExpanded: Bool, rows: Int) -> some View {
        self.multilineTextAlignment(.leading)
            .lineLimit(isExpanded ? nil : rows)
            .fixedSize(horizontal: false, vertical: true)
    }
}

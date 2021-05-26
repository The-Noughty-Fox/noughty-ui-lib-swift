import SwiftUI

public struct SegmentPicker<T, ID: Hashable, EachContent: View >: DynamicViewContent {
    public typealias Data = [T]
    
    public let data: [T]
    let idPath: KeyPath<T, ID>
    let forEachContent: (Int, T, Bool) -> EachContent
    let isSelected: (Int, T) -> Bool
    
    let barBackgoundColor: Color
    let barForegroundColor: Color
    let barHeight: CGFloat
    
    public init(
        dataSource: [T],
        idPath: KeyPath<T, ID>,
        barBackgoundColor: Color,
        barForegroundColor: Color,
        barHeight: CGFloat = 4,
        isSelected: @escaping (Int, T) -> Bool,
        forEachContent: @escaping (Int, T, Bool) -> EachContent
    ) {
        self.data = dataSource
        self.idPath = idPath
        self.isSelected = isSelected
        self.forEachContent = forEachContent
        self.barBackgoundColor = barBackgoundColor
        self.barForegroundColor = barForegroundColor
        self.barHeight = barHeight
    }
    
    public init(
        dataSource: [T],
        barBackgoundColor: Color,
        barForegroundColor: Color,
        barHeight: CGFloat = 4,
        isSelected: @escaping (Int, T) -> Bool,
        forEachContent: @escaping (Int, T, Bool) -> EachContent
    ) where T: Identifiable, T.ID == ID {
        self.data = dataSource
        self.idPath = \T.id
        self.isSelected = isSelected
        self.forEachContent = forEachContent
        self.barBackgoundColor = barBackgoundColor
        self.barForegroundColor = barForegroundColor
        self.barHeight = barHeight
    }
    
    @Namespace var ns
    @SwiftUI.State private var geometryEffectID: String = ""
    
    public var body: some View {
        HorizontalPicker(
            dataSource: data,
            idPath: idPath,
            isSelected: isSelected,
            forEachContent: { index, item, isSelected in
                forEachContent(index, item, isSelected)
                    .matchedGeometryEffect(id: "\(index)", in: ns, isSource: true)
                    .preference(key: SelectedItemId.self, value: isSelected ? "\(index)" : nil)
            }
        ).onPreferenceChange(SelectedItemId.self) { value in
            if geometryEffectID == "" {
                geometryEffectID = value ?? ""
            } else {
                withAnimation(.spring()) {
                    geometryEffectID = value ?? ""
                }
            }
        }
        // overlayPreference did not work...
        .overlay(
            Capsule()
                .fill(barBackgoundColor)
                .frame(height: barHeight)
                .overlay(
                    Capsule()
                        .fill(barForegroundColor)
                        .frame(height: barHeight)
                        .matchedGeometryEffect(id: geometryEffectID, in: ns, isSource: false)
                ),
            alignment: .bottom
        )
    }
}

// Fore some reason it worked ONLY when the preference is over String, AnyHashable did not work 🤷‍♂️
private struct SelectedItemId: PreferenceKey {
    static var defaultValue: String?
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue() ?? value
    }
}


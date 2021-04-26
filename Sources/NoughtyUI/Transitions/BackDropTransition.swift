import SwiftUI

extension AnyTransition {
    static func backDrop(target: CGFloat) -> Self {
        .modifier(active: BackDropTransition(progress: 0, targetOffset: target),
                  identity: BackDropTransition(progress: 1, targetOffset: target))
    }
}

struct BackDropTransition: GeometryEffect {
    var progress: Double
    let targetOffset: CGFloat
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let tranlation = targetOffset * CGFloat(1 - progress)
        let translate = CGAffineTransform(translationX: .zero, y: tranlation)
        return ProjectionTransform(translate)
    }
}

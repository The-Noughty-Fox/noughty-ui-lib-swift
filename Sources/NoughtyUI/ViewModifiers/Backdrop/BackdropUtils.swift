import CoreGraphics

public enum BackdropStage {
    case hidden
    case minimized
    case half
    case full
}

public enum BackDropDimension {
    case absolute(CGFloat)
    case relative(CGFloat)
    
    public var absoluteValue: CGFloat {
        switch self {
        case let .absolute(value):
            return value
        case let .relative(value):
            return value
        }
    }
    
    public func relativeValue(whole: CGFloat) -> CGFloat {
        switch self {
        case let .absolute(value):
            return value
        case let .relative(value):
            return whole * value
        }
    }
}
/// Config for contents of the backdrop
public struct BackDropContentConfig {
    public var offset: CGFloat
    public var height: CGFloat
    public var stage: BackdropStage
}

/// Config for the behaviour of the backdrop
public struct BackdropConfig {
    public let canBeExpanded: Bool
    public let canBeMinimized: Bool
    
    public let minimizedHeight: BackDropDimension
    public let halfHeight: BackDropDimension
    public let fullHeight: BackDropDimension
    public let initialStage: BackdropStage
    
    public init(canBeExpanded: Bool = true,
                canBeMinimized: Bool = true,
                minimizedHeight: BackDropDimension = .relative(0.1),
                halfHeight: BackDropDimension = .relative(0.5),
                fullHeight: BackDropDimension = .relative(0.9),
                initialStage: BackdropStage = .half) {
        self.canBeExpanded = canBeExpanded
        self.canBeMinimized = canBeMinimized
        self.minimizedHeight = minimizedHeight
        self.halfHeight = halfHeight
        self.fullHeight = fullHeight
        self.initialStage = initialStage
    }
}

extension BackdropConfig {
    public static var `default`: Self = .init(canBeMinimized: true)
    
    public static var halfOnly: Self = .init(canBeExpanded: false,
                                             canBeMinimized: false)
}



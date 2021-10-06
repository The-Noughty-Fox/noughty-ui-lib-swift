import CoreGraphics

extension CGPoint {
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x - rhs.x,
              y: lhs.y - rhs.y)
    }
    
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x,
              y: lhs.y + rhs.y)
    }
}

import CoreGraphics

public extension CGRect {
    var topLeft: CGPoint {
        return origin
    }

    var topRight: CGPoint {
        return CGPoint(x: size.width + origin.x, y: origin.y)
    }

    var bottomLeft: CGPoint {
        return CGPoint(x: origin.x, y: size.height + origin.y)
    }

    var bottomRight: CGPoint {
        return CGPoint(x: size.width + origin.x, y: size.height + origin.y)
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    func moved(by vector: CGVector) -> CGRect {
        return CGRect(
            x: origin.x + vector.dx,
            y: origin.y + vector.dy,
            width: width,
            height: height
        )
    }

    func maxRect(with ratio: CGFloat) -> CGRect {
        return CGRect(origin: origin, size: size.maxSize(with: ratio))
    }
}

public extension CGRect {
    init(origin: CGPoint = .zero, side: CGFloat) {
        self.init(origin: origin, size: .init(side: side))
    }

    init(origin: CGPoint = .zero, width: CGFloat, height: CGFloat) {
        self.init(origin: origin, size: .init(width: width, height: height))
    }
}

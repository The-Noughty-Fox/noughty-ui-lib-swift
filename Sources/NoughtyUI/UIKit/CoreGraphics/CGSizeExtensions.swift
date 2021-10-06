import CoreGraphics

public extension CGSize {
    var minSide: CGFloat {
        return min(width, height)
    }

    var maxSide: CGFloat {
        return max(width, height)
    }

    init(side: CGFloat) {
        self.init(width: side, height: side)
    }

    func maxSize(with ratio: CGFloat) -> CGSize {
        let currentRatio = width / height
        if currentRatio > ratio {
            return CGSize(width: height * ratio, height: height)
        } else if currentRatio < ratio {
            return CGSize(width: width, height: width / ratio)
        } else {
            return self
        }
    }
}

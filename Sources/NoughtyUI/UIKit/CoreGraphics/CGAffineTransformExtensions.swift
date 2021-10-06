import CoreGraphics
import UIKit

public extension CGAffineTransform {
    var ca3DTransform: CATransform3D {
        return CATransform3DMakeAffineTransform(self)
    }
}

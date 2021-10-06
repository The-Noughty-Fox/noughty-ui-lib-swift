import Foundation
import UIKit

public extension CATransform3D {
    static func + (lhs: CATransform3D, rhs: CATransform3D) -> CATransform3D {
        return lhs.append(rhs)
    }

    func append(_ transform: CATransform3D) -> CATransform3D {
        return CATransform3DConcat(self, transform)
    }
}

//Some convecience stuff
//hate those ...makeScale bs.
public extension CATransform3D {
    static func scale(sx: CGFloat, sy: CGFloat, sz: CGFloat = 1.0) -> CATransform3D {
        return CATransform3DMakeScale(sx, sy, sz)
    }
    
    //swiftlint:disable:next identifier_name
    static func rotate(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        return CATransform3DMakeRotation(angle, x, y, z)
    }

    static func translate(tx: CGFloat, ty: CGFloat, tz: CGFloat) -> CATransform3D {
        return CATransform3DMakeTranslation(tx, ty, tz)
    }

    static func affineTransorm(_ transform: CGAffineTransform) -> CATransform3D {
        return CATransform3DMakeAffineTransform(transform)
    }

    static var identity: CATransform3D {
        return CATransform3DIdentity
    }

    var cgAffineTransform: CGAffineTransform {
        return CATransform3DGetAffineTransform(self)
    }
}

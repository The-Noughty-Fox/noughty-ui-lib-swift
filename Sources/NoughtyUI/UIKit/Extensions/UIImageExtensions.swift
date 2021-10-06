import UIKit

public extension UIImage {
    ///Template representation
    var template: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }

    ///Original representation
    var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}

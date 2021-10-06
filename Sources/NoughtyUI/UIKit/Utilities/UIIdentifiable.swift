import Foundation
import UIKit

public protocol UIIdentifiable {
    static var identifier: String { get }
}

public extension UIIdentifiable {
    static var identifier: String {
        String(describing: self)
    }
}

public protocol NibLoadable: UIIdentifiable where Self: UIView {
    static var bundle: Bundle { get }
    static var nibName: String { get }
    static var nib: UINib { get }
    static func instantiate() -> Self
}

public extension NibLoadable {
    static var bundle: Bundle {
        Bundle(for: Self.self)
    }

    static var nibName: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: nibName, bundle: bundle)
    }

    static func instantiate() -> Self {
        let nibs = nib.instantiate(withOwner: nil, options: nil)
        guard let view = nibs.lazy.compactMap({ $0 as? Self }).first else {
            fatalError("Could not instantiate \(identifier) from nib file.")
        }

        return view
    }
}

public protocol StoryboardInstantiable: UIIdentifiable where Self: UIViewController {
    static var bundle: Bundle { get }
    static var storyboardName: String { get }
    static func instantiate() -> Self
}

public extension StoryboardInstantiable {
    static var bundle: Bundle {
        Bundle(for: Self.self)
    }

    static var storyboardName: String {
        identifier
    }

    private static var storyboard: UIStoryboard {
        UIStoryboard(name: storyboardName, bundle: bundle)
    }

    static func instantiate() -> Self {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Could not instantiate \(identifier) from storyboard file.")
        }

        return viewController
    }
}

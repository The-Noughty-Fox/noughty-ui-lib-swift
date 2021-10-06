//
//  UICollectionView+Extensions.swift
//  NyonOrder
//
//  Created by Lammert Westerhoff on 29/06/2017.
//  Copyright © 2017 Nyon Business B.V. All rights reserved.
//

import Foundation
import UIKit

/// Type of supplimentary view used to register supplimentary views in UICollectionView
public enum SupplementaryViewKind {
    /// UICollectionView.elementKindSectionHeader
    case header
    /// UICollectionView.elementKindSectionFooter
    case footer
    /// Your own element kind
    case custom(String)

    public var kind: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        case .custom(let string):
            return string
        }
    }
}

extension UICollectionView {
    public func register<Cell: UICollectionViewCell & NibLoadable>(_ type: Cell.Type) {
        register(type.nib, forCellWithReuseIdentifier: type.identifier)
    }

    public func register<Cell: UICollectionViewCell & UIIdentifiable>(_ type: Cell.Type) {
        register(type, forCellWithReuseIdentifier: type.identifier)
    }

    public func register<T: UICollectionReusableView & NibLoadable>(_ type: T.Type,
                                                                    forSupplementaryViewOfKind kind: SupplementaryViewKind) {
        register(type.nib, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: type.identifier)
    }

    public func register<T: UICollectionReusableView & UIIdentifiable>(_ type: T.Type,
                                                                     forSupplementaryViewOfKind kind: SupplementaryViewKind) {
        register(type, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: type.identifier)
    }
}

extension UICollectionView {
    public func dequeue<R: UIIdentifiable & UICollectionViewCell>(for indexPath: IndexPath) -> R {
        dequeue(R.self, for: indexPath)
    }

    public func dequeueSupplementaryView<R: UIIdentifiable & UICollectionReusableView>(for indexPath: IndexPath, kind: String) -> R {
        dequeueSupplementaryView(R.self, for: indexPath, kind: kind)
    }

    public func dequeue<R: UIIdentifiable & UICollectionViewCell>(_ type: R.Type, for indexPath: IndexPath) -> R {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? R else {
            fatalError("Could not dequeue cell: \(R.identifier)")
        }

        return cell
    }

    public func dequeueSupplementaryView<R: UIIdentifiable & UICollectionReusableView>(_ type: R.Type, for indexPath: IndexPath, kind: String) -> R {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: type.identifier,
                                                for: indexPath) as? R else {
            fatalError("Could not dequeue supplementary view: \(R.identifier)")
        }

        return supplementaryView
    }
}

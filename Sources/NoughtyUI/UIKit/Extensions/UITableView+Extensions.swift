//
//  UITableView+Extensions.swift
//  NyonOrder
//
//  Created by Lammert Westerhoff on 01/10/2016.
//  Copyright © 2016 Nyon Business B.V. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    public func register<T: UITableViewCell & NibLoadable>(_ type: T.Type) {
        register(type.nib, forCellReuseIdentifier: type.identifier)
    }

    public func register<T: UITableViewCell & UIIdentifiable>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }

    public func registerHeaderFooterView<T: UITableViewHeaderFooterView & NibLoadable>(_ type: T.Type) {
        register(type.nib, forHeaderFooterViewReuseIdentifier: type.identifier)
    }

    public func registerHeaderFooterView<T: UITableViewHeaderFooterView & UIIdentifiable>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: type.identifier)
    }
}

extension UITableView {
    public func dequeue<R: UITableViewCell & UIIdentifiable>(for indexPath: IndexPath) -> R {
        dequeue(R.self, for: indexPath)
    }

    public func dequeue<R: UITableViewCell & UIIdentifiable>(_ type: R.Type, for indexPath: IndexPath) -> R {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? R else {
            fatalError("Could not dequeue cell: \(R.identifier)")
        }

        return cell
    }

    public func dequeueSupplementaryView<R: UITableViewHeaderFooterView & UIIdentifiable>() -> R {
        guard let supplementaryView = dequeueReusableHeaderFooterView(withIdentifier: R.identifier) as? R else {
            fatalError("Could not dequeue HeaderFooterView: \(R.identifier)")
        }

        return supplementaryView
    }
}

extension UITableView {
    func scrollToBottom() {
        let lastSection = numberOfSections - 1
        let lastCell = numberOfRows(inSection: lastSection) - 1
        scrollToRow(at: IndexPath.init(row: lastCell, section: lastSection), at: .bottom, animated: true)
    }
}

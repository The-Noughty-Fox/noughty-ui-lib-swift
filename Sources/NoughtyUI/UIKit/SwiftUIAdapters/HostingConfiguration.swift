//
//  HostingConfiguration.swift
//  Enclaves
//
//  Created by Lisnic Victor on 21.09.2021.
//

import SwiftUI
import UIKit
import TinyConstraints

public struct HostingConfiguration<Content: SwiftUI.View>: UIContentConfiguration {
    public var parentController: UIViewController
    public var content: Content

    public init(
        parentController: UIViewController,
        content: Content
    ) {
        self.parentController = parentController
        self.content = content
    }

    public func makeContentView() -> UIView & UIContentView {
        HostingContentView(hostingConfiguration: self)
    }

    public func updated(for state: UIConfigurationState) -> HostingConfiguration {
        self
    }
}

public class HostingContentView<Content: SwiftUI.View>: UIView, UIContentView {
    public var configuration: UIContentConfiguration {
        get { hostingConfiguration }
        set {
            guard let configuration = newValue as? HostingConfiguration<Content> else { return }
            hostingConfiguration = configuration
            update(config: configuration)
        }
    }

    private var hostingConfiguration: HostingConfiguration<Content>
    private weak var hostingController: UIHostingController<Content>?

    public init(hostingConfiguration: HostingConfiguration<Content>) {
        self.hostingConfiguration = hostingConfiguration
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let hostingController = UIHostingController<Content>.init(rootView: hostingConfiguration.content)

        hostingController.willMove(toParent: hostingConfiguration.parentController)
        hostingConfiguration.parentController.addChild(hostingController)
        hostingController.didMove(toParent: hostingConfiguration.parentController)

        hostingController.view.in(self).then {
            $0.backgroundColor = .clear
            $0.edgesToSuperview()
            $0.invalidateIntrinsicContentSize()
        }

        self.hostingController = hostingController

        layoutSubviews()

        // For use in cells
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    deinit {
        hostingController?.willMove(toParent: nil)
        hostingController?.removeFromParent()
        hostingController?.view.removeFromSuperview()
        hostingController?.didMove(toParent: nil)
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        hostingController!.view.sizeThatFits(targetSize)
    }

    func disconnect() {
        hostingController?.view.removeFromSuperview()

        hostingController?.willMove(toParent: nil)
        hostingController?.removeFromParent()
        hostingController?.didMove(toParent: nil)

        hostingController = nil
    }

    func update(config: HostingConfiguration<Content>) {
        disconnect()
        setup()
    }


    public override func layoutSubviews() {
        hostingController?.view.invalidateIntrinsicContentSize()
        hostingController?.view.sizeToFit()
        contentHeight?.constant = hostingController?.view.bounds.height ?? 0

        super.layoutSubviews()
    }

    var _contentHeight: Constraint?
    var contentHeight: Constraint? {
        get {
            if let view = hostingController?.view {
                _contentHeight = _contentHeight ?? view.height(view.bounds.height)
                return _contentHeight
            }

            _contentHeight = nil
            return nil
        }
        set {
            _contentHeight = newValue
        }
    }
}


public class SwiftUIHostingCell<Content: SwiftUI.View>: UICollectionViewCell {
    public weak var host: UIViewController? {
        didSet {
            hostingController.willMove(toParent: host)
            host?.addChild(hostingController)
            hostingController.didMove(toParent: host)
        }
    }

    public var content: Content? {
        didSet {
            hostingController.rootView = content
            hostingController.view.invalidateIntrinsicContentSize()
            print(hostingController.view.intrinsicContentSize)
        }
    }
    private var hostingController: UIHostingController<Content?>

    public override init(frame: CGRect) {
        hostingController = UIHostingController(rootView: nil)
        super.init(frame: frame)
        hostingController.view.in(contentView).then { view in
            view.backgroundColor = .clear
            view.edgesToSuperview()
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        hostingController.view.invalidateIntrinsicContentSize()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        hostingController.view.invalidateIntrinsicContentSize()
    }

    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var layoutAttributes = layoutAttributes
        hostingController.view.sizeToFit()
        layoutAttributes.size.height = hostingController.view.frame.height
        return layoutAttributes
    }
}

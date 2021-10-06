import UIKit

public extension UIView {
    /**
     Frame relative to UIWindow.main
     */
    var frameInWindow: CGRect {
        return convert(bounds, to: nil)
    }

    /**
     Masks a view with a provided path.

     Creates a CAShapeLayer with a provided path and sets it to `layer.mask` property.
     Everything out of paths' shape will not be visible.

     - Important: Mask does not scale with view. Path must be created with size relative to final size of view,
     and recreated in case view scales.
     - Parameters:
        - path: A path that mask layer is created with.
     */
    func mask(with path: CGPath) {
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.black.cgColor
        mask.path = path
        layer.mask = mask
    }
}

public extension UIView {
    /**
     Corner radius applied to the view

     - Important: It's only affecting background, border, and shadow drawing.
     Every subview, image, or sublayer will not be clipped without setting `clipsToBounds` to true.
     */
    var layerCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    /// Color of the views border
    var borderColor: UIColor? {
        get { return layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue.flatMap { $0.cgColor } }
    }

    /**
     Line width of the views border

     Border is drawn inwards off views bounds, is drawn over all subviews and sublayers.
     */
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    /// Color of the views shadow
    var layerShadowColor: UIColor? {
        get { return layer.shadowColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.shadowColor = newValue.flatMap { $0.cgColor } }
    }

    /// The opacity of views shadow
    var layerShadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    /**
     The offset of views shadow

     Default value is (0.0, -3.0)
     */
    var layerShadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    /// Radius applied to the views shadow rendering
    var layerShadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    /**
     Path defining shadows shape

     Setting explisit shadow path can improve rendering perormance.
     */
    var shadowPath: CGPath? {
        get { return layer.shadowPath }
        set { layer.shadowPath = newValue }
    }

    /// Rounds view by its shortest side
    func makeRound() {
        layerCornerRadius = bounds.size.minSide / 2
    }

    /// Clips subviews by view's bounds combined with corner radius mask.
    func clipSubviews(_ clip: Bool) {
        clipsToBounds = clip
    }

    /// Corners to be rounded
    @available(iOS 11.0, *)
    var roundedCorners: CACornerMask {
        get { return layer.maskedCorners }
        set { layer.maskedCorners = newValue }
    }

    /**
     The insets that you use to determine the safe area for this view.

     - Important: Prior iOS 11 returns .zero
    */
    var safeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) { return safeAreaInsets }

        return .zero
    }
}

public extension UIView {
    /// Sets view's alpha to provided value. You can animate this stuff.
    func setAlpha(_ alpha: CGFloat) {
        self.alpha = alpha
    }

    /// Sets isHidden property to false.
    func show() {
        isHidden = false
    }

    /// Sets isHidden property to true.
    func hide() {
        isHidden = true
    }
}

public extension UIView {
    func removeShadow() {
        applyShadow(opacity: 0)
    }

    func applyShadow(opacity: Float = 0.5,
                     radius: CGFloat = 4,
                     offsetHeight: CGFloat = 2) {
        clipSubviews(false)
        layerShadowColor = .black
        layerShadowOffset = .init(width: 0, height: offsetHeight)
        layerShadowOpacity = opacity
        layerShadowRadius = radius
    }
}

extension UIView {
    /// Used to intercept placeholder view's decoded from storyboards
    /// and replace them with real ones to flatten the view hieararchy
    override open func awakeAfter(using aDecoder: NSCoder) -> Any? {
        guard !translatesAutoresizingMaskIntoConstraints,
            let nibType = type(of: self) as? (UIView & NibLoadable).Type else { return self }

        let replacement = nibType.instantiate()
        guard type(of: replacement) == nibType else { return self }

        transferProperties(to: replacement)
        let replacementConstraints = reparentedConstraints(to: replacement)
        replacement.addConstraints(replacementConstraints)

        return replacement
    }

    private func reparentedConstraints(to target: UIView) -> [NSLayoutConstraint] {
        return constraints.map { original in
            let first = self == original.firstItem as? UIView ? target : original.firstItem
            let second = self == original.secondItem as? UIView ? target : original.secondItem
            let constraint = NSLayoutConstraint(
                item: first!,
                attribute: original.firstAttribute,
                relatedBy: original.relation,
                toItem: second,
                attribute: original.secondAttribute,
                multiplier: original.multiplier,
                constant: original.constant)
            constraint.priority = original.priority
            constraint.shouldBeArchived = original.shouldBeArchived
            constraint.identifier = original.identifier
            constraint.isActive = original.isActive

            return constraint
        }
    }

    private func transferProperties(to target: UIView) {
        target.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        target.autoresizingMask = autoresizingMask
        target.isHidden = isHidden
        target.tag = tag
        target.isUserInteractionEnabled = isUserInteractionEnabled
        target.frame = frame
        target.bounds = bounds
        target.clipsToBounds = clipsToBounds
    }
}


public extension UIView {
    @discardableResult
    func `in`(_ superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
}

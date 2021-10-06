import UIKit

public struct GradientStep {
    public let location: Float
    public let color: UIColor

    public init(location: Float, color: UIColor) {
        self.location = location
        self.color = color
    }
}

public extension CAGradientLayer {
    static func linearGradient(startColor: UIColor, endColor: UIColor,
                               startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        return CAGradientLayer(
            steps: [
                GradientStep(location: 0, color: startColor),
                GradientStep(location: 1, color: endColor)
            ],
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    convenience init(steps: [GradientStep], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.set(steps: steps)
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    func set(steps: [GradientStep]) {
        colors = steps.map { $0.color.cgColor }
        locations = steps.map { NSNumber(value: $0.location) }
    }

    func animate(steps: [GradientStep], duration: TimeInterval) {
        let locationsAnimation = CABasicAnimation(keyPath: "locations")
        locationsAnimation.duration = duration
        locationsAnimation.toValue = steps.map { NSNumber(value: $0.location) }
        locationsAnimation.fillMode = .forwards
        add(locationsAnimation, forKey: "locationsAnimation")
        let colorsAnimation = CABasicAnimation(keyPath: "colors")
        colorsAnimation.duration = duration
        colorsAnimation.toValue = steps.map { $0.color.cgColor }
        colorsAnimation.fillMode = .forwards
        add(colorsAnimation, forKey: "colorsAnimation")
    }
}

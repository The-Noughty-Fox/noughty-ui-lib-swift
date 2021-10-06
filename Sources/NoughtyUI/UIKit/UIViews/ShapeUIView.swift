//
//  ShapeUIView.swift
//  
//
//  Created by Lisnic Victor on 22.09.2021.
//

import Foundation
import UIKit

public class ShapeUIView: UIView {
    public var fillColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }

    public var strokeColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }

    public var strokeWidth: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }

    public var path: CGPath? {
        didSet {
            setNeedsDisplay()
        }
    }

    public  init(
        path: CGPath = .init(rect: .zero, transform: nil),
        fillColor: UIColor = .blue,
        strokeColor: UIColor = .blue,
        strokeWidth: CGFloat = 2
    ) {
        self.path = path
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func draw(_ rect: CGRect) {
        guard let path = path else {
            return
        }
        let context = UIGraphicsGetCurrentContext()

        var transform = CGAffineTransform(translationX: 1, y: 1)
        let fpath = path.resized(to: rect.inset(by: .uniform(1)))

        context?.addPath(fpath.copy(using: &transform)!)
        context?.setFillColor(fillColor.cgColor)
        context?.setStrokeColor(strokeColor.cgColor)
        context?.setLineWidth(strokeWidth)
        context?.strokePath()

        super.draw(rect)
    }
}


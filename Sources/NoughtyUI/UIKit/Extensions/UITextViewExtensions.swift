import UIKit

public extension UITextView {
    /**
     Sets insets for text relative to text view bounds.

     This method just sets `textContainerInset` property ignoring the existance of
     `textContainer.lineFragmentPadding`
     which adds padding at the start of the line.

     - Important: This method sets `textContainer.lineFragmentPadding` to 0.
     - Parameters:
        - insets: The text inset from text view's bounds.
    */
    func setAbsoluteTextInsets(insets: UIEdgeInsets) {
        textContainerInset = insets
        textContainer.lineFragmentPadding = 0
    }

    /**
     Returns height of the text view in between base and max heights calculated by its content and width

     - Important: Width should be set before calling this method.
     - Parameters:
        - baseHeight: Initial and minimum height of text view.
        - maxHeight: Maximum height of text view
     */
    func newHeight(withBaseHeight baseHeight: CGFloat, maxHeight: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let fixedWidth = frame.size.width
        let newHeight = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)).height
        if newHeight < baseHeight { return baseHeight }
        if newHeight > maxHeight { return maxHeight }

        return newHeight
    }
}

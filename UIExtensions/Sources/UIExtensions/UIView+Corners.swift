import UIKit

public extension UIView {
    func addCornerRadius(_ corners: UIRectCorner, _ radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        layer.masksToBounds = true
    }
}

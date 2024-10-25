import UIKit

public extension UIView {
    static func autoLayout<T: UIView>() -> T {
        let view = T.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view as T
    }
}

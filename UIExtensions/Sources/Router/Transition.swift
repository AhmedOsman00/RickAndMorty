import UIKit

public protocol Transition {
    func open(_ to: UIViewController?,
              _ from: UIViewController,
              animated: Bool,
              completion: (() -> Void)?)
}

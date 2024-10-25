import UIKit

public struct PopTransition: @preconcurrency Transition {

    public init() {}

    @MainActor public func open(_ to: UIViewController?,
                     _ from: UIViewController,
                     animated: Bool,
                     completion: (() -> Void)? = nil) {
        guard let navigationController = from.navigationController else {
            fatalError("Navigation controller should be available")
        }

        navigationController.popViewController(animated: animated)
        completion?()
    }
}

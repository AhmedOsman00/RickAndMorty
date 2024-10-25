import UIKit

public struct PushTransition: @preconcurrency Transition {

    public init() {}

    @MainActor public func open(_ to: UIViewController?,
                     _ from: UIViewController,
                     animated: Bool,
                     completion: (() -> Void)? = nil) {
        guard let navigationController = from.navigationController,
              let to else {
            fatalError("Navigation controller should be available")
        }
        
        navigationController.pushViewController(to, animated: animated)
        completion?()
    }
}

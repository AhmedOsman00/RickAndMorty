import UIKit

public protocol Router {
    associatedtype Destination

    func navigate(to destination: Destination, completion: (()->Void)?)
}

public class Navigator {

    public init() {}

    @MainActor public func navigate(to destination: UIViewController? = nil,
                         as transition: Transition,
                         animated: Bool = true,
                         completion: (()->Void)? = nil) {
        guard let topViewController = UIApplication.shared.keyWindow?.appTopViewController else {
            return assertionFailure("Context is not available")
        }

        transition.open(destination, topViewController, animated: animated, completion: completion)
    }
}

extension UIApplication {
    public var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
                   .filter { $0.activationState == .foregroundActive }
                   .compactMap { $0 as? UIWindowScene }
                   .first?.windows
                   .filter { $0.isKeyWindow }
                   .first
    }
}


extension UIWindow: @preconcurrency TopViewControllerProvider {
    var appTopViewController: UIViewController? {
        var topViewController = rootViewController
        while let topViewControllerProvider = topViewController?.appTopViewController {
            topViewController = topViewControllerProvider
        }
        return topViewController
    }
}

protocol TopViewControllerProvider {
    var appTopViewController: UIViewController? { get }
}

extension UITabBarController {
    override var appTopViewController: UIViewController? {
        selectedViewController
    }
}

extension UINavigationController {
    override var appTopViewController: UIViewController? {
        visibleViewController
    }
}

extension UIViewController: @preconcurrency TopViewControllerProvider {
    @objc var appTopViewController: UIViewController? {
        presentedViewController
    }
}

import SwiftUI
import UIKit

public struct HostingContentConfiguration<Content>: UIContentConfiguration where Content: View {
    fileprivate let hostingController: UIHostingController<Content>

    @MainActor
    init(@ViewBuilder content: () -> Content) {
        hostingController = UIHostingController(rootView: content())
    }
    
    public func makeContentView() -> UIView & UIContentView {
        ContentView<Content>(self)
    }
    
    public func updated(for state: UIConfigurationState) -> HostingContentConfiguration<Content> {
        self
    }
}

private class ContentView<Content>: UIView, UIContentView where Content: View {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ configuration: UIContentConfiguration) {
        guard let configuration = configuration as? HostingContentConfiguration<Content>,
              let parent = findViewController() else {
            return
        }
        
        let hostingController = configuration.hostingController
        
        guard let swiftUICellView = hostingController.view,
              subviews.isEmpty else {
            hostingController.view.invalidateIntrinsicContentSize()
            return
        }
        
        hostingController.view.backgroundColor = .clear
        
        parent.addChild(hostingController)
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingAnchor.constraint(equalTo: swiftUICellView.leadingAnchor),
            trailingAnchor.constraint(equalTo: swiftUICellView.trailingAnchor),
            topAnchor.constraint(equalTo: swiftUICellView.topAnchor),
            bottomAnchor.constraint(equalTo: swiftUICellView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        hostingController.didMove(toParent: parent)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.findViewController()
        }
        
        return nil
    }
}

@MainActor public func host<Content: View>(@ViewBuilder content: () -> Content) -> any UIContentConfiguration {
    if #available(iOS 16.0, *) {
        UIHostingConfiguration(content: content)
    } else {
        HostingContentConfiguration(content: content)
    }
}

import UIKit
import Router

public typealias CharacterDetailsFactory = (CharacterUiModel) -> CharacterDetailsViewController
public struct CharactersRouter: @preconcurrency Router {
    private let navigator: Navigator
    private let factory: CharacterDetailsFactory

    public init(navigator: Navigator, factory: @escaping CharacterDetailsFactory) {
        self.navigator = navigator
        self.factory = factory
    }

    public enum Destination {
        case details(CharacterUiModel)
    }

    @MainActor public func navigate(to destination: Destination, completion: (() -> Void)? = nil) {
        switch destination {
        case let .details(model):
            navigator.navigate(to: factory(model), as: PushTransition())
        }
    }
}


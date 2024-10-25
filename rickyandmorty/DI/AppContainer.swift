import Foundation
import Networking
import Pager
import Characters
import Router

let container = Container.shared

struct AppContainer {
    func assemble() {
        container.register(HttpClientProtocol.self) { _ in
            HttpClient(session: URLSession.shared)
        }

        container.register(PagerProtocol.self) {
            Pager(httpClient: $0.resolved())
        }

        container.register(DataDecoder.self) { _ in
            JSONDecoder()
        }

        container.register(Navigator.self) { _ in
            Navigator()
        }

        container.register(CharacterDetailsFactory.self) { _ in
            { (model) -> CharacterDetailsViewController in
                CharacterDetailsViewController(characterUiModel: model)
            }
        }

        container.register(CharactersViewController.self) {
            let dataSource = CharactersRemoteDataSource(pager: $0.resolved(), jsonDecoder: $0.resolved())
            let viewModel = CharactersViewModel(dataSource: dataSource)
            let router = CharactersRouter(navigator: $0.resolved(), factory: $0.resolved())
            return CharactersViewController(viewModel: viewModel, router: router)
        }
    }
}

import Foundation
import Pager
import Networking

enum CharactersEndpoint: PageableEndpoint {
    case all

    var path: String {
        switch self {
        case .all:
            "/api/character"
        }
    }

    var method: HttpMethod {
        switch self {
        case .all:
            .GET
        }
    }

    var pageQueryParameterName: String {
        "page"
    }

    var countQueryParameter: (name: String, value: UInt) {
        ("count", 20)
    }
}

extension PagerProtocol {
    func nextPage<T: Pageable>(_ endpoint: CharactersEndpoint,
                               _ decoder: DataDecoder) async throws -> T? {
        try await nextPage(endpoint: endpoint, decoder: decoder)
    }

    func firstPage<T: Pageable>(_ endpoint: CharactersEndpoint,
                                _ decoder: DataDecoder) async throws -> T? {
        try await firstPage(endpoint: endpoint, decoder: decoder)
    }
}

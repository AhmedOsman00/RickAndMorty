import Networking
import Pager

public protocol CharactersRemoteDataSourceInterface {
    func getCharacters() async throws -> Characters?
    func getNextCharacters() async throws -> Characters?
}

public struct CharactersRemoteDataSource: CharactersRemoteDataSourceInterface {
    let pager: PagerProtocol
    let jsonDecoder: DataDecoder

    public init(pager: PagerProtocol, jsonDecoder: DataDecoder) {
        self.pager = pager
        self.jsonDecoder = jsonDecoder
    }

    public func getCharacters() async throws -> Characters? {
        try await pager.firstPage(.all, jsonDecoder)
    }

    public func getNextCharacters() async throws -> Characters? {
        try await pager.nextPage(.all, jsonDecoder)
    }
}

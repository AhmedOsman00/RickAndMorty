import XCTest
import Combine
@testable import Characters

final class MockCharactersRemoteDataSource: CharactersRemoteDataSourceInterface {
    var shouldReturnError = false
    var mockCharacters: Characters?

    func getCharacters() async throws -> Characters? {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockCharacters
    }

    func getNextCharacters() async throws -> Characters? {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockCharacters
    }
}

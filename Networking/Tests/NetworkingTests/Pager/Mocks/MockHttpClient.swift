import Foundation
@testable import Networking

class MockHttpClient: HttpClientProtocol {
    var resultData: Data?
    var shouldThrowError = false

    func data<T: Decodable>(request: URLRequest, decoder: DataDecoder) async throws -> T {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        guard let data = resultData else {
            throw URLError(.badServerResponse)
        }

        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
}

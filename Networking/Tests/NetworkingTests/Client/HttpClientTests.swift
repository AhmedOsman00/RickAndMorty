import Testing
import Foundation
@testable import Networking

struct MockModel: Decodable {
    let name: String
}

struct HttpClientTests {

    let mockSession: MockURLSession
    let client: HttpClientProtocol

    init() {
        self.mockSession = MockURLSession()
        self.client = HttpClient(session: mockSession)
    }

    @Test
    func successfulResponse() async throws {
        // Arrange
        let mockData = "{\"name\":\"Test\"}".data(using: .utf8)
        mockSession.dataToReturn = mockData
        mockSession.responseToReturn = createHTTPURLResponse(statusCode: 200)

        // Act
        let result: MockModel = try await client.data(endpoint: MockEndpoint(), decoder: JSONDecoder())
        
        // Assert
        #expect(result.name == "Test")
    }

    @Test
    func failedResponseWithAPIError() async throws {
        // Arrange
        let mockData = "{\"error\":\"Invalid request\"}".data(using: .utf8)
        mockSession.dataToReturn = mockData
        mockSession.responseToReturn = createHTTPURLResponse(statusCode: 400)

        // Act & Assert
        let error = NetworkError.api(ApiError(error: "Invalid request"))
        await #expect(throws: error, performing: {
            let _: MockModel = try await client.data(endpoint: MockEndpoint(), decoder: JSONDecoder())
        })
    }

    @Test
    func noResponseError() async throws {
        // Arrange
        mockSession.dataToReturn = nil
        mockSession.responseToReturn = nil
        
        // Act & Assert
        await #expect(throws: NetworkError.noResponse, performing: {
            let _: MockModel = try await client.data(endpoint: MockEndpoint(), decoder: JSONDecoder())
        })
    }

    func createHTTPURLResponse(statusCode: Int) -> HTTPURLResponse? {
        .init(url: URL(string: "https://example.com")!,
              statusCode: statusCode,
              httpVersion: nil,
              headerFields: nil)
    }
}

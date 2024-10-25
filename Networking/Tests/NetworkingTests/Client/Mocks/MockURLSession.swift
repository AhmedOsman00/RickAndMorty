import Foundation
@testable import Networking

class MockURLSession: URLSessionProtocol {
    var dataToReturn: Data?
    var responseToReturn: URLResponse?

    static var `default`: any URLSessionProtocol {
        MockURLSession()
    }

    func data(_ urlRequest: URLRequest) async throws -> (Data?, URLResponse?) {
        return (dataToReturn, responseToReturn)
    }
}

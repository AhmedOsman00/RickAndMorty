import Foundation

public protocol Endpoint: URLRequestConvertible {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: [String: String]? { get }
    var body: HttpBody? { get }
    var headers: [String: String] { get }
}

public extension Endpoint {
    var baseUrl: URL {
        guard let url = URL(string: "https://rickandmortyapi.com") else {
            fatalError("Invalid Base Url")
        }
        return url
    }

    var queryParameters: [String: String]? { nil }
    var body: HttpBody? { nil }
    var headers: [String: String] { [:] }
}

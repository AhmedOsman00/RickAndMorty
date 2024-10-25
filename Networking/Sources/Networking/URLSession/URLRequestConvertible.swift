import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible where Self: Endpoint {
    public func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        urlComponents?.path = path
        urlComponents?.queryItems = queryParameters?.map { .init(name: $0.0, value: $0.1) }

        guard let url = urlComponents?.url,
                baseUrl.scheme != nil,
                baseUrl.host != nil
        else { throw NetworkError.invalidUrl }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body.flatMap { $0.data }

        return urlRequest
    }
}

public extension HttpClientProtocol {
    func data<T: Decodable>(endpoint: any URLRequestConvertible, decoder: DataDecoder) async throws -> T {
        try await data(request: endpoint.asURLRequest(), decoder: decoder)
    }
}

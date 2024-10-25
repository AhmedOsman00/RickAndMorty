import Foundation
import Networking

public protocol PageableEndpoint: Endpoint {
    var pageQueryParameterName: String { get }
    var countQueryParameter: (name: String, value: UInt) { get }
}

extension URLRequestConvertible where Self: PageableEndpoint {
    public func asURLRequest(page: UInt) throws -> URLRequest {
        var urlRequest = try asURLRequest()
        if let url = urlRequest.url,
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems = urlComponents.queryItems ?? []
            
            queryItems.append(contentsOf: [
                URLQueryItem(name: pageQueryParameterName, value: String(page)),
                URLQueryItem(name: countQueryParameter.name, value: String(countQueryParameter.value))
            ])
            
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }

        return urlRequest
    }
}

extension HttpClientProtocol {
    func data<T: Decodable>(pageableEndpoint: any PageableEndpoint,
                            page: UInt,
                            decoder: DataDecoder) async throws -> T {
        try await data(request: pageableEndpoint.asURLRequest(page: page), decoder: decoder)
    }
}

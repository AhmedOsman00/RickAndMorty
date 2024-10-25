import Foundation

public protocol HttpClientProtocol {
    func data<T: Decodable>(request: URLRequest, decoder: DataDecoder) async throws -> T
}

public class HttpClient: HttpClientProtocol {
    let successStatusCodeRange = 200...299
    let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }

    public func data<T: Decodable>(request: URLRequest, decoder: DataDecoder) async throws -> T {
        let (data, httpResponse) = try await session.data(request)

        guard let data else { throw NetworkError.noResponse }

        guard let response = httpResponse.flatMap({ $0 as? HTTPURLResponse }),
              successStatusCodeRange ~= response.statusCode else {
            let error = try decoder.decode(ApiError.self, from: data)
            throw NetworkError.api(error)
        }

        return try decoder.decode(T.self, from: data)
    }
}

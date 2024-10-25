import Foundation

public enum NetworkError: Equatable, Error, LocalizedError {
    case decodingFailed
    case invalidUrl
    case noResponse
    case api(ApiError)

    public var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return String(localized: "Failed to decode the response.")
        case .invalidUrl:
            return String(localized: "The provided URL is invalid.")
        case .noResponse:
            return String(localized: "No data was received from the server.")
        case let .api(apiError):
            return apiError.error
        }
    }
}

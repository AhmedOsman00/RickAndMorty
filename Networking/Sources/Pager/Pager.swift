import Foundation
import Networking

public protocol PagerProtocol {
    var currentPage: UInt { get }
    func nextPage<T: Pageable>(endpoint: any PageableEndpoint, decoder: DataDecoder) async throws -> T?
    func firstPage<T: Pageable>(endpoint: any PageableEndpoint, decoder: DataDecoder) async throws -> T?
}

public final class Pager: PagerProtocol {
    private let httpClient: HttpClientProtocol
    private var totalPages = UInt.max
    public private(set) var currentPage: UInt = 0

    public init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }

    public func nextPage<T: Pageable>(endpoint: any PageableEndpoint,
                                      decoder: DataDecoder) async throws -> T? {
        guard currentPage < totalPages else {
            return nil
        }

        let newPage = currentPage + 1
        let page: T = try await httpClient.data(pageableEndpoint: endpoint, page: newPage, decoder: decoder)
        currentPage = newPage
        totalPages = page.totalPages
        return page
    }

    public func firstPage<T: Pageable>(endpoint: any PageableEndpoint, decoder: DataDecoder) async throws -> T? {
        currentPage = 0
        return try await nextPage(endpoint: endpoint, decoder: decoder)
    }
}

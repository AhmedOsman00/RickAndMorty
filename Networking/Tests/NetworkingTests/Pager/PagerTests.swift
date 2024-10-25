import Testing
import Foundation
@testable import Networking

struct PagerTests {
    let pager: Pager
    let mockHttpClient: MockHttpClient
    let mockDecoder: JSONDecoder
    
    init() {
        mockHttpClient = MockHttpClient()
        pager = Pager(httpClient: mockHttpClient)
        mockDecoder = JSONDecoder()
    }

    @Test
    func firstPageSuccess() async throws {
        // Mock data for the first page
        let mockResponse = MockPageable(totalPages: 3, elements: [
            MockPageable.Element(id: 1, name: "Element 1"),
            MockPageable.Element(id: 2, name: "Element 2")
        ])
        
        let responseData = try JSONEncoder().encode(mockResponse)
        mockHttpClient.resultData = responseData
        
        let endpoint = MockPageableEndpoint()

        // Test firstPage fetching the first page
        let page: MockPageable? = try await pager.firstPage(endpoint: endpoint, decoder: mockDecoder)
        let _: MockPageable? = try await pager.firstPage(endpoint: endpoint, decoder: mockDecoder)
        
        #expect(page?.totalPages == 3)
        #expect(page?.elements.count == 2)
        #expect(pager.currentPage == 1)
    }

    @Test
    func nextPageSuccess() async throws {
        // Mock data for the second page
        let mockResponse = MockPageable(totalPages: 3, elements: [
            MockPageable.Element(id: 3, name: "Element 3"),
            MockPageable.Element(id: 4, name: "Element 4")
        ])
        
        let responseData = try JSONEncoder().encode(mockResponse)
        mockHttpClient.resultData = responseData
        
        let endpoint = MockPageableEndpoint()
        // Test nextPage fetching the second page
        let page: MockPageable? = try await pager.nextPage(endpoint: endpoint, decoder: mockDecoder)
        
        #expect(page?.totalPages == 3)
        #expect(page?.elements.count == 2)
        #expect(pager.currentPage == 1)
    }

    @Test
    func nextPageNoMorePages() async throws {
        // Mock data for the last page
        let mockResponse = MockPageable(totalPages: 2, elements: [])
        let responseData = try JSONEncoder().encode(mockResponse)
        mockHttpClient.resultData = responseData
        
        let endpoint = MockPageableEndpoint()

        // Test nextPage when there are no more pages
        let _: MockPageable? = try await pager.nextPage(endpoint: endpoint, decoder: mockDecoder)
        let _: MockPageable? = try await pager.nextPage(endpoint: endpoint, decoder: mockDecoder)
        let page: MockPageable? = try await pager.nextPage(endpoint: endpoint, decoder: mockDecoder)
        
        #expect(page == nil)
        #expect(pager.currentPage == 2)
    }

    @Test
    func nextPageNoData() async throws {
        // Mock data for the last page
        let mockResponse = MockPageable(totalPages: 0, elements: [])
        let responseData = try JSONEncoder().encode(mockResponse)
        mockHttpClient.resultData = responseData
        
        let endpoint = MockPageableEndpoint()

        // Test nextPage when there are no more pages
        let page: MockPageable? = try await pager.nextPage(endpoint: endpoint, decoder: mockDecoder)
        
        #expect(pager.currentPage == 1)
        #expect(page?.elements == [])
    }

    @Test
    func errorOnPageRequest() async {
        // Simulate an error response from the HttpClient
        mockHttpClient.shouldThrowError = true
        
        let endpoint = MockPageableEndpoint()
        
        do {
            let _: MockPageable? = try await pager.firstPage(endpoint: endpoint, decoder: mockDecoder)
            #expect(pager.currentPage == 0)
        } catch {}
    }
}

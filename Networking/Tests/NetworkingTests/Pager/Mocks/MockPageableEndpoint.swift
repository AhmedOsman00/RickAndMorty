import Foundation
@testable import Networking

struct MockPageableEndpoint: PageableEndpoint {
    var baseUrl: URL = URL(string: "https://example.com")!
    var path: String = "/mock"
    var method: HttpMethod = .GET
    var queryParameters: [String : String]? = nil
    var body: HttpBody? = nil
    var headers: [String: String] = [:]
    let pageQueryParameterName: String = "page"
    let countQueryParameter: (name: String, value: UInt) = ("count", 20)
}

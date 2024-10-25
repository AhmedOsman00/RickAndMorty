import Foundation
@testable import Networking

struct MockPageable: Pageable, Encodable {
    struct Element: Decodable, Equatable, Encodable {
        let id: Int
        let name: String
    }

    let totalPages: UInt
    let elements: [Element]
}

public protocol Pageable: Decodable {
    var totalPages: UInt { get }
}

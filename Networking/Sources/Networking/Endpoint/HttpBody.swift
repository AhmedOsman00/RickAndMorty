import Foundation

public struct HttpBody {
    let data: Data

    static func json<T: Encodable>(_ body: T, encoder: DataEncoder = JSONEncoder()) throws -> Self {
        let data = try encoder.encode(body)
        return .init(data: data)
    }
}

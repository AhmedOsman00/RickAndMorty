import Pager

public struct Characters: Pageable {
    let info: Info
    let results: [Character]

    public var totalPages: UInt {
        info.pages
    }

    init(info: Info, results: [Character]) {
        self.info = info
        self.results = results
    }
}

public struct Info: Decodable {
    let pages: UInt

    init(pages: UInt) {
        self.pages = pages
    }
}

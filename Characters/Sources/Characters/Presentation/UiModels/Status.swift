import SwiftUI

enum Status: String, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
}

extension Status {
    var backgroundColor: Color {
        switch self {
        case .alive:
            .frostedSky
        case .dead:
            .softRose
        case .unknown:
            .gainsboro
        }
    }

    var isBordered: Bool {
        switch self {
        case .unknown:
            true
        default:
            false
        }
    }
}

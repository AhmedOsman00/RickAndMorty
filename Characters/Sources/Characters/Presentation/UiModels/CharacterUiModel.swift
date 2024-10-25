import Foundation

public struct CharacterUiModel: Hashable {
    let name: String
    let status: Status
    let species: String
    let gender: String
    let image: URL
    let origin: String
}

extension CharacterUiModel {
    init(_ model: Character) {
        name = model.name
        status = .init(rawValue: model.status) ?? .unknown
        species = model.species
        gender = model.gender
        image = model.image
        origin = model.origin.name
    }
}

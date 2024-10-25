import Foundation

public struct Character: Decodable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: URL
    let origin: CharacterLocation

    init(name: String, status: String, species: String, gender: String, image: URL, origin: CharacterLocation) {
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.image = image
        self.origin = origin
    }
}

public struct CharacterLocation: Decodable {
    let name: String

    init(name: String) {
        self.name = name
    }
}

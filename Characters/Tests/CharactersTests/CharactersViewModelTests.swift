import Testing
import Foundation
import Combine
@testable import Characters

struct CharactersViewModelTests {
    let viewModel: CharactersViewModel
    let mockDataSource: MockCharactersRemoteDataSource
    let cancellables: Set<AnyCancellable>
    
    init() {
        mockDataSource = MockCharactersRemoteDataSource()
        viewModel = CharactersViewModel(dataSource: mockDataSource)
        cancellables = []
    }

    @Test
    func fetchCharactersSuccess() async {
        // Given
        mockDataSource.mockCharacters = createCharacters()

        // When
        await viewModel.fetchCharacters()

        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.items.count == 2)
        #expect(viewModel.items.first?.name == "Test1")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func fetchCharactersFailure() async {
        // Given
        mockDataSource.shouldReturnError = true

        // When
        await viewModel.fetchCharacters()

        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.items.count == 0)
    }

    @Test
    func fetchMoreCharactersSuccess() async {
        // Given
        mockDataSource.mockCharacters = createCharacters()

        // When
        await viewModel.fetchCharacters()
        mockDataSource.mockCharacters = createCharacters()
        await viewModel.fetchMoreCharacters()

        // Then
        #expect(viewModel.items.count == 4)
        #expect(viewModel.items.last?.name == "Test2")
    }

    @Test
    func filterCharacters() async {
        // Given
        mockDataSource.mockCharacters = createCharacters()

        // When
        await viewModel.fetchCharacters()
        viewModel.filterCharacters(by: .dead)

        // Then
        #expect(viewModel.items.count == 1)
        #expect(viewModel.items.first?.name == "Test2")
    }

    private func createCharacters() -> Characters {
        let character1 = Character(name: "Test1",
                                   status: "Alive",
                                   species: "",
                                   gender: "",
                                   image: URL(string: "https://example.com")!,
                                   origin: .init(name: ""))
        let character2 = Character(name: "Test2",
                                   status: "Dead",
                                   species: "",
                                   gender: "",
                                   image: URL(string: "https://example.com")!,
                                   origin: .init(name: ""))
        return Characters(info: .init(pages: 1), results: [character1, character2])
    }
}

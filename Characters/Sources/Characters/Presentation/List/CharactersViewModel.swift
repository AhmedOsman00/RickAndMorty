import Foundation
import Combine

public final class CharactersViewModel {
    @Published private var allItems: [CharacterUiModel] = []
    @Published private(set) var items: [CharacterUiModel] = []
    @Published private(set) var filters: [FilterUiModel] = Status.allCases.map { .init($0) }
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let dataSource: CharactersRemoteDataSourceInterface

    public init(dataSource: CharactersRemoteDataSourceInterface) {
        self.dataSource = dataSource
        bind()
    }

    private func bind() {
        Publishers.CombineLatest($allItems, $filters)
            .map { items, filters -> [CharacterUiModel] in
                guard let selectedFilter = filters.first(where: { $0.isSelected }) else {
                    return items
                }
                return items.filter { $0.status == selectedFilter.status }
            }
            .assign(to: &$items)
    }

    func fetchCharacters() async {
        isLoading = true
        
        do {
            guard let fetchedItems = try await dataSource.getCharacters() else { return }
            allItems = fetchedItems.results.map { CharacterUiModel($0) }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    func fetchMoreCharacters() async {
        do {
            guard let fetchedItems = try await dataSource.getNextCharacters() else { return }
            allItems.append(contentsOf: fetchedItems.results.map { CharacterUiModel($0) })
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func filterCharacters(by status: Status) {
        filters = filters.map { filter in
            let isSelected = (filter.status == status) ? !filter.isSelected : false
            return .init(status: filter.status, isSelected: isSelected)
        }
    }
}

import UIKit
import SwiftUI
import Combine
import UIExtensions

public final class CharactersViewController: BaseViewController {
    private let viewModel: CharactersViewModel
    private let router: CharactersRouter
    private static let cellIdentifier = "Cell"
    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var cancellables = Set<AnyCancellable>()
    private lazy var charactersDataSource: UITableViewDiffableDataSource<Section, CharacterUiModel> = {
        UITableViewDiffableDataSource<Section, CharacterUiModel>(tableView: charactersTableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            cell.contentConfiguration = host {
                CharacterCell(name: item.name,
                              specie: item.species,
                              imageUrl: item.image,
                              backgroundColor: item.status.backgroundColor,
                              isBordered: item.status.isBordered)
            }
            return cell
        }
    }()
    
    private lazy var filtersDataSource: UICollectionViewDiffableDataSource<Section, FilterUiModel> = {
        UICollectionViewDiffableDataSource<Section, FilterUiModel>(collectionView: filtersCollectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath)
            cell.contentConfiguration = host {
                FilterCell(model: item)
            }
            return cell
        }
    }()
    
    enum Section {
        case main
    }

    public init(viewModel: CharactersViewModel, router: CharactersRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupActivityIndicator()
        setupTableView()
        setupCollectionView()
        bindViewModel()
        
        Task {
            await viewModel.fetchCharacters()
        }
    }

    private func setupTitle() {
        title = String(localized: "Characters", bundle: .resources)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }

    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.updateTableView(with: items)
            }
            .store(in: &cancellables)
        
        viewModel.$filters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.updateCollectionView(with: items)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        charactersTableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        charactersTableView.separatorStyle = .none
        charactersTableView.delegate = self
    }
    
    private func setupCollectionView() {
        filtersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Self.cellIdentifier)
        filtersCollectionView.delegate = self
    }

    private func updateTableView(with items: [CharacterUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterUiModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        charactersDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateCollectionView(with items: [FilterUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FilterUiModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        filtersDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension CharactersViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = charactersDataSource.itemIdentifier(for: indexPath) else { return }

        router.navigate(to: .details(selectedItem))
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)

        if indexPath.row == totalRows - 1 {
            Task {
                await viewModel.fetchMoreCharacters()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let status = filtersDataSource.itemIdentifier(for: indexPath)?.status else { return }
        viewModel.filterCharacters(by: status)
    }
}

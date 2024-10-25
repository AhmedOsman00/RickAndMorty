import UIKit
import SDWebImage
import UIExtensions

public final class CharacterDetailsViewController: BaseViewController {
    let model: CharacterUiModel

    private let imageView: UIImageView = {
        let imageView: UIImageView = .autoLayout()
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label: UILabel = .autoLayout()
        label.font = .systemFont(ofSize: 35)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label: UILabel = .autoLayout()
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    private let locationLabel: UILabel = {
        let label: UILabel = .autoLayout()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    private let statusLabel: UILabel = {
        let label: UILabel = .autoLayout()
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.backgroundColor = .red
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private let horizontalStackContainer: UIStackView = {
        let stack: UIStackView = .autoLayout()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let verticalStackContainer: UIStackView = {
        let stack: UIStackView = .autoLayout()
        stack.axis = .vertical
        return stack
    }()
    
    public init(characterUiModel: CharacterUiModel) {
        self.model = characterUiModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupData()
    }
    
    private func setupData() {
        imageView.sd_setImage(with: model.image)
        nameLabel.text = model.name
        descriptionLabel.text = "\(model.species) • \(model.gender)"
        statusLabel.text = model.status.rawValue
        statusLabel.backgroundColor = UIColor(model.status.backgroundColor)
        locationLabel.text = String(localized: "Location: \(model.origin)", bundle: .resources)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.addCornerRadius([.bottomLeft, .bottomRight], 20)
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        [
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
        ].forEach { $0.isActive = true }

        view.addSubview(horizontalStackContainer)
        [nameLabel, descriptionLabel].forEach(verticalStackContainer.addArrangedSubview)
        [verticalStackContainer, statusLabel].forEach(horizontalStackContainer.addArrangedSubview)
        [
            horizontalStackContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            horizontalStackContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            horizontalStackContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ].forEach { $0.isActive = true }

        view.addSubview(locationLabel)
        [
            locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 20),
            locationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            locationLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            locationLabel.topAnchor.constraint(equalTo: horizontalStackContainer.bottomAnchor, constant: 20)
        ].forEach { $0.isActive = true }
    }
}

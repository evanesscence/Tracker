import UIKit

class CategoriesController: UIViewController {
    private let defaultImage = UIImageView()
    private let defaultContainer = UIStackView()
    private let defaultLabel = UILabel()
    private let addCategoryButton = DarkButton(title: "Добавить категорию")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Категория"
        view.backgroundColor = .tWhite
        
        setupDefaultInfo()
        setupAddCategoryButton()
    }
    
    private func setupDefaultInfo() {
        defaultContainer.axis = .vertical
        defaultContainer.spacing = 8
        defaultContainer.distribution = .fill
        defaultContainer.alignment = .fill
        
        defaultImage.image = UIImage(named: "TrackersDefault")
        defaultImage.contentMode = .scaleAspectFit
        
        defaultLabel.text = "Привычки и события можно \n объединить по смыслу"
        defaultLabel.textAlignment = .center
        defaultLabel.numberOfLines = 2
        defaultLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        defaultLabel.textColor = .tBlack
        
        view.addSubview(defaultContainer)
        defaultContainer.addArrangedSubview(defaultImage)
        defaultContainer.addArrangedSubview(defaultLabel)
        
        defaultContainer.translatesAutoresizingMaskIntoConstraints = false
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            defaultContainer.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            defaultContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            defaultContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupAddCategoryButton() {
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        view.addSubview(addCategoryButton)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    @objc
    private func addCategoryButtonTapped() {
        let vc = NewCategoryController()
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
}

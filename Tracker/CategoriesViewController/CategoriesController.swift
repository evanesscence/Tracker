import UIKit

protocol CategoriesControllerProtocol: AnyObject {
    func newCategoryWasAdded(with name: String)
}

final class CategoriesController: UIViewController {
    weak var delegate: EventsControllerProtocol?
    private let defaultImage = UIImageView()
    private let defaultContainer = UIStackView()
    private let defaultLabel = UILabel()
    private let addCategoryButton = DarkButton(title: "Добавить категорию")
    private var categories = [TrackerCategory(name: "Важное", trackers: []), TrackerCategory(name: "Домашние дела", trackers: [])]
    
    private let categoriesTableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Категория"
        view.backgroundColor = .tWhite
        
        if categories.isEmpty {
            setupDefaultInfo()
        }
        
        setupAddCategoryButton()
        setupCategoryTableView()
        
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
    
    private func setupCategoryTableView() {
        categoriesTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        view.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16)
        ])
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
    }
    
    private func configureCellCorners(_ cell: UITableViewCell, indexPath: IndexPath) {
           let cornerRadius: CGFloat = 16
           let maskLayer = CAShapeLayer()
           let bounds = cell.bounds
           
           if indexPath.row == 0 && indexPath.row == categories.count - 1 {
               // Единственная ячейка
               maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
           } else if indexPath.row == 0 {
               // Первая ячейка
               maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
           } else if indexPath.row == categories.count - 1 {
               // Последняя ячейка
               maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
           } else {
               // Средние ячейки
               maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [], cornerRadii: CGSize(width: 0, height: 0)).cgPath
           }
           
           cell.layer.mask = maskLayer
       }
    
    @objc
    private func addCategoryButtonTapped() {
        let vc = NewCategoryController()
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
}

extension CategoriesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else {
            print("err")
            return
        }
        
        cell.shouldShowDoneIcon()
        categoriesTableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didConfirm(with: categories[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == categories.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
}

extension CategoriesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) 
        cell.textLabel?.text = categories[indexPath.row].name
        cell.backgroundColor = .tLightGray30
        configureCellCorners(cell, indexPath: indexPath)
        return cell
    }
    
}

extension CategoriesController: CategoriesControllerProtocol {
    func newCategoryWasAdded(with name: String) {
        let newCategory = TrackerCategory(name: name, trackers: [])
        categories.append(newCategory)
        setupCategoryTableView()
        categoriesTableView.reloadData()
    }
}


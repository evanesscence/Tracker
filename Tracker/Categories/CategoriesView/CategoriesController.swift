import UIKit

protocol CategoriesControllerProtocol: AnyObject {
    func newCategoryWasAdded()
}

final class CategoriesController: UIViewController {
    weak var delegate: EventsControllerProtocol?
    private let defaultImage = UIImageView()
    private let defaultContainer = UIStackView()
    private let defaultLabel = UILabel()
    private let addCategoryButton = DarkButton(title: NSLocalizedString("addCategoryButton", comment: ""))
    private let viewModel: CategoriesViewModel
    
    private let categoriesTableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var trackerCategoryStore = {
        let trackerCategoryStore = TrackerCategoryStore.shared
        return trackerCategoryStore
    }()
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("category", comment: "")
        view.backgroundColor = .tWhite

        setupAddCategoryButton()
        bindViewModel()
        viewModel.loadCategories()
    }
    
    private func bindViewModel() {
        viewModel.categoriesBinding = { [weak self] categories in
            guard let self = self else { return }
            viewSetup(with: categories)
            categoriesTableView.reloadData()
        }
        
        categoriesTableView.reloadData()
    }
    
    private func viewSetup(with categories: [CategoryViewModel]) {
        if categories.isEmpty {
            self.setupDefaultInfo()
        } else {
            self.setupCategoryTableView()
        }
        self.categoriesTableView.reloadData()
    }
    
    private func setupDefaultInfo() {
        defaultContainer.axis = .vertical
        defaultContainer.spacing = 8
        defaultContainer.distribution = .fill
        defaultContainer.alignment = .fill
        
        defaultImage.image = UIImage(named: "TrackersDefault")
        defaultImage.contentMode = .scaleAspectFit
        
        defaultLabel.text = NSLocalizedString("eventsGrouped", comment: "")
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
        categoriesTableView.tableHeaderView = UIView()
        categoriesTableView.layer.cornerRadius = 16
        categoriesTableView.clipsToBounds = true
        categoriesTableView.alwaysBounceVertical = false
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
    
    @objc
    private func addCategoryButtonTapped() {
        let vc = NewCategoryController(viewModel: CategoriesViewModel(categoryStore: TrackerCategoryStore()))
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
        viewModel.selectCategory(category: viewModel.categories[indexPath.row])
        
        viewModel.selectedCategory?.nameBinding = { [weak self] name in
            guard let self = self else { return }
            self.delegate?.didConfirm(with: name)
        }
        
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else {
            return nil
        }
        
        let contextMenu = UIContextMenuConfiguration(
            actionProvider: { actions in
                return UIMenu(
                    children: [
                        UIAction(title: NSLocalizedString("edit", comment: "")) { [weak self] _ in
                            guard let self = self else { return }
                            AnalyticsService().report(event: "click", params: ["screen" : "Main", "item" : "edit"])
                            
                            let editCategoryController = NewCategoryController(viewModel: CategoriesViewModel(categoryStore: TrackerCategoryStore()))
                            let navigationController = UINavigationController(rootViewController: editCategoryController)
                            
                            editCategoryController.isCategoryEditing = true
                            editCategoryController.changedCategory = viewModel.categories[indexPath.row].name
                            
                            present(navigationController, animated: true)
                        },
                        
                        UIAction(title: NSLocalizedString("delete", comment: ""), attributes: .destructive) { [weak self] _ in
                            guard let self = self else { return }
                            AnalyticsService().report(event: "click", params: ["screen" : "Main", "item" : "delete"])
                            
                            if TrackerCategoryStore().hasTrackers(viewModel.categories[indexPath.row].name) {
                                let alertModel = AlertModel(
                                    title: NSLocalizedString("deleteCategoryAlertTitle", comment: ""),
                                    message: NSLocalizedString("deleteCategoryAlertMessage", comment: "")
                                )
                                let alert = Alert().showWarningAlert(for: alertModel, action: nil)
                                present(alert, animated: true)
                            } else {
                                let alertModel = AlertModel(
                                    title: nil,
                                    message: NSLocalizedString("deleteCategoryWarning", comment: "")
                                )
                                
                                let alert = Alert().showDeleteAlert(for: alertModel) { [weak self] action in
                                    guard let self = self else { return }
                                    
                                    try? TrackerCategoryStore().deleteCategory(viewModel.categories[indexPath.row].name)
                                }
                                present(alert, animated: true)
                            }
                        }
                    ]
                )
            })
        
        return contextMenu
    }
    
}

extension CategoriesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let category = viewModel.categories[indexPath.row]
        category.nameBinding = { name in
            cell.setCategoryName(name)
        }
        
        cell.viewModel = viewModel.categories[indexPath.item]
        cell.backgroundColor = .tLightGray30
        
        if indexPath.row == viewModel.categories.count-1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        return cell
    }
}





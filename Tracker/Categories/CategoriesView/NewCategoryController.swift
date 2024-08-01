import UIKit

final class NewCategoryController: UIViewController {
    var isCategoryEditing = false
    var changedCategory: String?
    
    private var newCategory: String?
    private let trackerLabelTextField = TextField()
    private let confirmButton = DarkButton(title: NSLocalizedString("doneButton", comment: ""))
    private let viewModel: CategoriesViewModel
    
    private lazy var dataProvider: TrackerCategoryStoreProtocol? = {
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
        navigationItem.title = isCategoryEditing ? NSLocalizedString("editCategory", comment: "") : NSLocalizedString("newCategory", comment: "")
        view.backgroundColor = .white
        
        setupConfirmButton()
        trackerLabelTextFieldConfig()
        setupToHideKeyboardOnTapOnView()
    }
    
    private func setupConfirmButton() {
        confirmButton.backgroundColor = .tTextFieldLabel
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func trackerLabelTextFieldConfig() {
        trackerLabelTextField.addTarget(self, action: #selector(trackerLabelTextFieldChanged(_:)), for: .editingChanged)
        view.addSubview(trackerLabelTextField)
        trackerLabelTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerLabelTextField.backgroundColor = .tLightGray30
        trackerLabelTextField.layer.cornerRadius = 16
        trackerLabelTextField.placeholder = NSLocalizedString("enterCategoryTitle", comment: "")
        trackerLabelTextField.textColor = .tBlack
        trackerLabelTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerLabelTextField.clearButtonMode = .whileEditing
        
        
        NSLayoutConstraint.activate([
            trackerLabelTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerLabelTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerLabelTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerLabelTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func confirmButtonIsEnabled() {
        if trackerLabelTextField.hasText {
            confirmButton.backgroundColor = .tBlack
            confirmButton.isEnabled = true
        }
        
        else {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = .tTextFieldLabel
        }
        
    }
    
    private func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func confirmButtonTapped() {
        if let newCategory = newCategory {
            if let changedCategory = changedCategory {
                viewModel.editCategory(oldCategoryName: changedCategory, newCategoryName: newCategory)
            } else {
                viewModel.addNewCategory(category: TrackerCategory(name: newCategory, trackers: []))
            }
        }
        
        dismiss(animated: true)
    }
    
    @objc
    private func trackerLabelTextFieldChanged(_ textField: UITextField) {
        newCategory = textField.text
        confirmButtonIsEnabled()
    }
}


import UIKit

final class NewCategoryController: UIViewController {
    weak var delegate: CategoriesControllerProtocol?
    private var newCategory: String?
    private let trackerLabelTextField = TextField()
    private let confirmButton = DarkButton(title: "Готово")
    
    override func viewDidLoad() {
        navigationItem.title = "Новая категория"
        view.backgroundColor = .white
        
        setupConfirmButton()
        trackerLabelTextFieldConfig()
    }
    
    private func setupConfirmButton() {
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
        trackerLabelTextField.placeholder = "Введите название категории"
        trackerLabelTextField.textColor = .tBlack
        trackerLabelTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        
        NSLayoutConstraint.activate([
            trackerLabelTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerLabelTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerLabelTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerLabelTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @objc
    private func confirmButtonTapped() {
        if let newCategory = newCategory {
            delegate?.newCategoryWasAdded(with: newCategory)
        }
        dismiss(animated: true)
    }
    
    @objc
    private func trackerLabelTextFieldChanged(_ textField: UITextField) {
        newCategory = textField.text
    }

}


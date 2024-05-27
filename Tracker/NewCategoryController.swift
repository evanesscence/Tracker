import UIKit

final class NewCategoryController: UIViewController {
    private let categories = ["Важное", "Радостные мелочи", "Домашние дела"]
    private let categoriesTableView = {
        let tableView = UITableView()
        tableView.register(NewCategoryTableViewCell.self, forCellReuseIdentifier: NewCategoryTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private let confirmButton = DarkButton(title: "Готово")
    
    override func viewDidLoad() {
        navigationItem.title = "Новая категория"
        view.backgroundColor = .white
        
        setupConfirmButton()
        setupCategoryTableView()
    }
    
    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupCategoryTableView() {
        categoriesTableView.layer.cornerRadius = 16
        categoriesTableView.clipsToBounds = true
        categoriesTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        view.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * categories.count))
        ])
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
    }
}

extension NewCategoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewCategoryTableViewCell else {
            print("err")
            return
        }
        cell.selectionStyle = .none
        cell.shouldShowDoneIcon()
        categoriesTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewCategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewCategoryTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        
        if indexPath.row == categories.count-1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
        
        return cell
    }
    
    
}

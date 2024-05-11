import UIKit

class TrackersViewController: UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var newCategories: [TrackerCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "AddButton"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let dateButton = UIButton()
        dateButton.setTitle(" 03.05.24 ", for: .normal)
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        dateButton.setTitleColor(.tBlack, for: .normal)
        dateButton.backgroundColor = .tGray
        dateButton.clipsToBounds = true
        dateButton.layer.cornerRadius = 8
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dateButton)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .tBlack
    
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        let searchBar = UISearchTextField()
        searchBar.placeholder = "Поиск"
        searchBar.backgroundColor = .tWhite
        searchBar.translatesAutoresizingMaskIntoConstraints = false
      
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        let defaultImage = UIImageView()
        defaultImage.image = UIImage(named: "TrackersDefault")
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
      
        view.addSubview(defaultImage)
        
        NSLayoutConstraint.activate([
            defaultImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            defaultImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            defaultImage.widthAnchor.constraint(equalToConstant: 80),
            defaultImage.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let defaultText = UILabel()
        defaultText.translatesAutoresizingMaskIntoConstraints = false
        defaultText.text = "Что будем отслеживать?"
        defaultText.font = .systemFont(ofSize: 12, weight: .medium)
        defaultText.textColor = .tBlack
    
        view.addSubview(defaultText)
        
        NSLayoutConstraint.activate([
            defaultText.centerXAnchor.constraint(equalTo: defaultImage.centerXAnchor),
            defaultText.topAnchor.constraint(equalTo: defaultImage.bottomAnchor, constant: 8)
        ])
        
    }
}

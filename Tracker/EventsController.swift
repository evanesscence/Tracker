import UIKit

protocol EventsControllerProtocol: AnyObject {
    func didConfirm(with days: [DaysOfWeek])
}

enum TypeOfEvent {
    case habbit
    case irregularEvent
}

enum Properties: String, CaseIterable {
    case category = "Категория"
    case sсhedule = "Расписание"
}

class EventsController: UIViewController {
    let emoji = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"]
    var type: TypeOfEvent
    init(type: TypeOfEvent) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let trackerLabelTextField = TextField()
    private var properties = [String]()
    private var selectedDays: String?
    
    private let eventPropertiesTable = {
        let tableView = UITableView()
        tableView.register(TrackerPropertiesCell.self, forCellReuseIdentifier: TrackerPropertiesCell.reuseIdentifier)
        return tableView
    }()
    
    private let collectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(EmojiViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupEventData()
        
        trackerLabelTextFieldConfig()
        eventPropertiesTableConfig()
        collectionViewConfig()
    }
    
    private func setupEventData() {
        switch type {
        case .habbit:
            title = "Новая привычка"
            properties = ["Категория", "Расписание"]
            break
        case .irregularEvent:
            title = "Новое нерегулярное событие"
            properties = ["Категория"]
            break
        }
    }
    
    private func trackerLabelTextFieldConfig() {
        view.addSubview(trackerLabelTextField)
        trackerLabelTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerLabelTextField.backgroundColor = .tLightGray30
        trackerLabelTextField.layer.cornerRadius = 16
        trackerLabelTextField.placeholder = "Введите название трекера"
        trackerLabelTextField.textColor = .tBlack
        trackerLabelTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        
        NSLayoutConstraint.activate([
            trackerLabelTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerLabelTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerLabelTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerLabelTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func eventPropertiesTableConfig() {
        eventPropertiesTable.layer.cornerRadius = 16
        eventPropertiesTable.alwaysBounceVertical = false
        eventPropertiesTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        view.addSubview(eventPropertiesTable)
        eventPropertiesTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventPropertiesTable.topAnchor.constraint(equalTo: trackerLabelTextField.bottomAnchor, constant: 24),
            eventPropertiesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            eventPropertiesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            eventPropertiesTable.heightAnchor.constraint(equalToConstant: CGFloat(75 * properties.count))
        ])
        
        eventPropertiesTable.delegate = self
        eventPropertiesTable.dataSource = self
    }
    
    private func collectionViewConfig() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: eventPropertiesTable.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setViewController(for property: String) -> UIViewController {
        var vc = UIViewController()
        if property == Properties.category.rawValue {
            let categoriesController = CategoriesController()
            vc = categoriesController
        }
        
        if property == Properties.sсhedule.rawValue {
            let scheduleController = ScheduleController()
            scheduleController.delegate = self
            vc = scheduleController
        }
        return vc
    }
}

extension EventsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerPropertiesCell.reuseIdentifier, for: indexPath) as? TrackerPropertiesCell else {
            print("error")
            return UITableViewCell()
        }
        
        if indexPath.row == properties.count-1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
        
        let cellModel = TrackerPropertiesModel(title: properties[indexPath.row], image: UIImage(named: "Arrow") ?? UIImage(), selectedDays: selectedDays)
        
        cell.configCell(for: cellModel)
        return cell
    }
}

extension EventsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = setViewController(for: properties[indexPath.row])
        present(UINavigationController(rootViewController: vc), animated: true)
        
    }
}

extension EventsController: UICollectionViewDelegate {
    
}

extension EventsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiViewCell else {
            print("error")
            return UICollectionViewCell()
        }
        
        cell.emoji.text = emoji[indexPath.row]
        cell.emoji.font = UIFont.systemFont(ofSize: 52)
        
        return cell
    }
    
}

extension EventsController: EventsControllerProtocol {
    func didConfirm(with days: [DaysOfWeek]) {
        if days.count == 7 {
            selectedDays = "Каждый день"
        } else {
            selectedDays = days.map { $0.day.shortFormat()}.joined(separator: ", ")
        }
        eventPropertiesTable.reloadData()
    }
}

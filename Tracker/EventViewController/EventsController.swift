import UIKit

protocol EventsControllerProtocol: AnyObject {
    func didConfirm(with days: [DaysOfWeek])
    func didConfirm(with category: TrackerCategory)
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
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private var properties = [String]()
    private var selectedDays: String?
    private var selectedCategory: String?
    private var schedule: [DaysOfWeek]?
    
    private let trackerLabelTextField = TextField()
    private let hintOfTextField = UILabel()
    private let trackerTextFieldContainer = UIStackView()
    
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private var buttonsContainer = UIStackView()
    
    
    private var didSelectedDays = false
    private var didSelectedCategory = false
    
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
        
        setupToHideKeyboardOnTapOnView()
        trackerLabelTextField.delegate = self
        
        view.backgroundColor = .white
        setupEventData()
        
        trackerLabelTextFieldConfig()
        eventPropertiesTableConfig()
//        collectionViewConfig()
        setupButtons()
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
        view.addSubview(trackerTextFieldContainer)
        
        trackerTextFieldContainer.axis = .vertical
        trackerTextFieldContainer.spacing = 8
        trackerTextFieldContainer.alignment = .fill
        trackerTextFieldContainer.distribution = .fill
        
        trackerTextFieldContainer.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        trackerTextFieldContainer.isLayoutMarginsRelativeArrangement = true
        
        trackerTextFieldContainer.addArrangedSubview(trackerLabelTextField)
        trackerTextFieldContainer.addArrangedSubview(hintOfTextField)
        
        trackerTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        trackerLabelTextField.translatesAutoresizingMaskIntoConstraints = false
        hintOfTextField.translatesAutoresizingMaskIntoConstraints = false
        
        trackerLabelTextField.backgroundColor = .tLightGray30
        trackerLabelTextField.layer.cornerRadius = 16
        trackerLabelTextField.placeholder = "Введите название трекера"
        trackerLabelTextField.clearButtonMode = .whileEditing
        trackerLabelTextField.textColor = .tBlack
        trackerLabelTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        trackerLabelTextField.addTarget(self, action: #selector(trackerLabelTextFieldEditingChanged(_:)), for: .editingChanged)
        
        hintOfTextField.isHidden = true
        hintOfTextField.textAlignment = .center
        hintOfTextField.text = "Ограничение 38 символов"
        hintOfTextField.textColor = .tRed
        hintOfTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        
        NSLayoutConstraint.activate([
            trackerTextFieldContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            trackerTextFieldContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerTextFieldContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
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
            eventPropertiesTable.topAnchor.constraint(equalTo: trackerTextFieldContainer.bottomAnchor, constant: 24),
            eventPropertiesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            eventPropertiesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            eventPropertiesTable.heightAnchor.constraint(equalToConstant: CGFloat(75 * properties.count))
        ])
        
        eventPropertiesTable.delegate = self
        eventPropertiesTable.dataSource = self
    }
    
//    private func collectionViewConfig() {
//        view.addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: eventPropertiesTable.bottomAnchor, constant: 50),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            collectionView.heightAnchor.constraint(equalToConstant: 170)
//        ])
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
    
    private func setupButtons() {
        buttonsContainer.axis = .horizontal
        buttonsContainer.spacing = 8
    
        buttonsContainer.distribution = .fillEqually
        
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.backgroundColor = .tWhite
        cancelButton.setTitleColor(.tRed, for: .normal)
        cancelButton.layer.borderColor = UIColor.tRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
       
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.isEnabled = false
        createButton.backgroundColor = .tTextFieldLabel
        createButton.setTitleColor(.tWhite, for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        view.addSubview(buttonsContainer)
        buttonsContainer.addArrangedSubview(cancelButton)
        buttonsContainer.addArrangedSubview(createButton)
        
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
       
    }
    
    private func setViewController(for property: String) -> UIViewController {
        var vc = UIViewController()
        if property == Properties.category.rawValue {
            let categoriesController = CategoriesController()
            categoriesController.delegate = self
            vc = categoriesController
        }
        
        if property == Properties.sсhedule.rawValue {
            let scheduleController = ScheduleController()
            scheduleController.delegate = self
            vc = scheduleController
        }
        return vc
    }
    
    private func createButtonIsEnabled() {
        if (type == .habbit) && (didSelectedDays) && (didSelectedCategory) && (trackerLabelTextField.hasText)
        {
            createButton.isEnabled = true
            createButton.backgroundColor = .tBlack
        }
        
        else if (type == .irregularEvent) && (didSelectedCategory) && (trackerLabelTextField.hasText) {
            createButton.isEnabled = true
            createButton.backgroundColor = .tBlack
        }
        
        else {
            createButton.isEnabled = false
            createButton.backgroundColor = .tTextFieldLabel
        }
        
    }
    
    private func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    @objc
    private func trackerLabelTextFieldEditingChanged(_ textField: UITextField) {
        hintOfTextField.isHidden = trackerLabelTextField.text?.count == 38 ? false : true
        createButtonIsEnabled()
    }
    
    @objc
    private func cancelButtonTapped() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc
    private func createButtonTapped() {
        if type == .habbit {
            guard let selectedCategory = selectedCategory, let trackerName = trackerLabelTextField.text, let schedule = schedule else { return }
            let newHabbit = TrackerCategory(
                name: selectedCategory,
                trackers:
                    [Tracker(
                        id: UUID(),
                        name: trackerName,
                        color: .tMildBlue,
                        emoji: emoji.randomElement() ?? "🍉",
                        schedule: schedule)
                    ])
            delegate?.createdNewTracker(tracker: newHabbit)
        } else {
            guard let selectedCategory = selectedCategory, let trackerName = trackerLabelTextField.text else { return }
            let newHabbit = TrackerCategory(
                name: selectedCategory,
                trackers:
                    [Tracker(
                        id: UUID(),
                        name: trackerName,
                        color: .tMildBlue,
                        emoji: emoji.randomElement() ?? "🍉",
                        schedule: [])
                    ])
            delegate?.createdNewTracker(tracker: newHabbit)
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}

extension EventsController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        let cellModel = TrackerPropertiesModel(title: properties[indexPath.row], image: UIImage(named: "Arrow") ?? UIImage(), selectedDays: selectedDays, selectedCategory: selectedCategory)
        
        cell.configCell(for: cellModel)
        return cell
    }
}

extension EventsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventPropertiesTable.deselectRow(at: indexPath, animated: true)
        let vc = setViewController(for: properties[indexPath.row])
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

//extension EventsController: UICollectionViewDelegate {
//    
//}
//
//extension EventsController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 18
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiViewCell else {
//            print("error")
//            return UICollectionViewCell()
//        }
//        
//        cell.emoji.text = emoji[indexPath.row]
//        cell.emoji.font = UIFont.systemFont(ofSize: 52)
//        
//        return cell
//    }
//    
//}

extension EventsController: EventsControllerProtocol {
    func didConfirm(with category: TrackerCategory) {
        selectedCategory = category.name
        
        didSelectedCategory = true
        createButtonIsEnabled()
        eventPropertiesTable.reloadData()
    }
    
    func didConfirm(with days: [DaysOfWeek]) {
        if days.count == 7 {
            selectedDays = "Каждый день"
            
        } else {
            selectedDays = days.map { $0.day.shortFormat()}.joined(separator: ", ")
        }
        
        schedule = days
        didSelectedDays = true
        createButtonIsEnabled()
        eventPropertiesTable.reloadData()
    }
}

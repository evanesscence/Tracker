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
    var collectionElements = [CollectionElements]()
    
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
    
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    
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
        collection.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.reusedIdentifier)
        collection.register(TrackerHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionElements = UICollectionElements.shared.elements
        
        setupScrollAndContentViews()
        setupToHideKeyboardOnTapOnView()
        trackerLabelTextField.delegate = self
        
        view.backgroundColor = .white
        setupEventData()
        
        trackerLabelTextFieldConfig()
        eventPropertiesTableConfig()
        setupButtons()
        collectionViewConfig()
        
    }
    
    private func setupScrollAndContentViews() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(contentView)
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
        contentView.addSubview(trackerTextFieldContainer)
        
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
            trackerTextFieldContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            trackerTextFieldContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerTextFieldContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerLabelTextField.heightAnchor.constraint(equalToConstant: 75)
            
        ])
    }
    
    private func eventPropertiesTableConfig() {
        eventPropertiesTable.layer.cornerRadius = 16
        eventPropertiesTable.alwaysBounceVertical = false
        eventPropertiesTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        contentView.addSubview(eventPropertiesTable)
        eventPropertiesTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventPropertiesTable.topAnchor.constraint(equalTo: trackerTextFieldContainer.bottomAnchor, constant: 24),
            eventPropertiesTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventPropertiesTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventPropertiesTable.heightAnchor.constraint(equalToConstant: CGFloat(75 * properties.count))
        ])
        
        eventPropertiesTable.delegate = self
        eventPropertiesTable.dataSource = self
    }
 //
    private func collectionViewConfig() {
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: eventPropertiesTable.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: -16)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
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
        
        contentView.addSubview(buttonsContainer)
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
                        emoji: "🍉",
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
                        emoji: "🍉",
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiViewCell {
            cell.didtapped()
            collectionView.allowsMultipleSelection = false
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiViewCell {
            cell.deselect()
            print("j")
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
           
        }
    }
    
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

extension EventsController: UICollectionViewDelegate {
    
}

extension EventsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerSize = CGSize(width: collectionView.bounds.width, height: 19)
        return headerView.systemLayoutSizeFitting(headerSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfItemsPerRow: CGFloat = 6
//        let spacing: CGFloat = 10
//        
//        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
//        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
//        
//        return CGSize(width: width, height: width)
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 40, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension EventsController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerHeaderCollectionView else {
            print("err")
            return UICollectionReusableView()
        }
        
        let sectionTitle = collectionElements[indexPath.section].elementsName
        section.configSectionTitle(for: sectionTitle)
        
        return section
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionElements[section].elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reusedCell = UICollectionViewCell()
        
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiViewCell {
                cell.emoji.text = collectionElements[indexPath.section].elements[indexPath.row]
                cell.emoji.font = UIFont.systemFont(ofSize: 32)
                
                reusedCell = cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reusedIdentifier, for: indexPath) as? ColorCollectionViewCell {
    
                let cellColor = collectionElements[indexPath.section].elements[indexPath.row]
                cell.configCell(with: cellColor)
                
                reusedCell = cell
            }
        }
        
        return reusedCell
    }
    
}

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

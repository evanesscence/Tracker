import UIKit

class TrackersViewController: UIViewController {
    private let dataManager = DataManager.shared
    
    var completedTrackers: [TrackerRecord] = []
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    
    private lazy var searchBar: UISearchTextField = {
        let textField = UISearchTextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private let searchBarContainer = UIStackView()
    private let searchBarCancelButton = UIButton()
    private let addButton = UIButton()
    private let datePickerLabel = UILabel()
    
    private var trackerCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reusedIdentifier)
        collectionView.register(TrackerHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collectionView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 77).isActive = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var dateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.leftBarButtonItem?.tintColor = .tBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        title = "Трекеры"
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34, weight: .bold), .foregroundColor: UIColor.tBlack]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        reloadData()
        setupDefaultInfo()
        setupSearchBar()
        setupAddButton()
        setupDatePickerLabel()
        setupTrackerCollectionView()
    }
    
    private func reloadData() {
        categories = dataManager.categories
        datePickerValueChanged()
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
       
        addButton.setImage(UIImage(named: "AddButton"), for: .normal)
        addButton.addTarget(self, action: #selector(createNewTracker), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupDatePickerLabel() {
        datePickerLabel.text = dateFormatter.string(from: datePicker.date)
        datePickerLabel.layer.cornerRadius = 8
        datePickerLabel.layer.masksToBounds = true
        
        datePickerLabel.textAlignment = .center
        datePickerLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        datePickerLabel.backgroundColor = .tGray
        datePickerLabel.textColor = .tBlack
        
        view.addSubview(datePicker)
        datePicker.addSubview(datePickerLabel)
        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePickerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            datePickerLabel.heightAnchor.constraint(equalToConstant: 34),
            datePickerLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBarContainer)
        searchBarContainer.addArrangedSubview(searchBar)
        searchBarContainer.addArrangedSubview(searchBarCancelButton)
        
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarContainer.axis = .horizontal
        searchBarContainer.spacing = 5
        searchBarContainer.alignment = .fill
        searchBarContainer.distribution = .fill
        
        searchBar.placeholder = "Поиск"
        searchBar.backgroundColor = .tWhite
        searchBar.clearButtonMode = .never
        searchBar.addTarget(self, action: #selector(searchBarTapped), for: .editingDidBegin)
        
        searchBarCancelButton.isHidden = true
        searchBarCancelButton.setTitle("Отменить", for: .normal)
        searchBarCancelButton.setTitleColor(.tBlue, for: .normal)
        searchBarCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchBarCancelButton.addTarget(self, action: #selector(searchBarCancelButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBarContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 36),
            searchBarCancelButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setupDefaultInfo() {
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
    
    private func setupTrackerCollectionView() {
        trackerCollectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        trackerCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(trackerCollectionView)
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 10),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
    }
    
    private func reloadVisibleCategroies() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
      
        let filterText = (searchBar.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.day.rawValue == filterWeekDay
                }
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                name: category.name,
                trackers: trackers
            )
        }
        
        trackerCollectionView.reloadData()
        showPlaceholder()
    }
    
    private func showPlaceholder() {
        trackerCollectionView.isHidden = visibleCategories.isEmpty
    }
    
    @objc func datePickerValueChanged() {
        datePickerLabel.text = dateFormatter.string(from: datePicker.date)
        reloadVisibleCategroies()
    }
        
    @objc func createNewTracker() {
        let newTracker = UINavigationController(rootViewController: NewTrackerController())
        present(newTracker, animated: true, completion: nil)
    }
    
    
    @objc func textFieldEditingChanged() {
        reloadVisibleCategroies()
    }
    
    @objc func searchBarTapped() {
        searchBarCancelButton.isHidden = false
    }
    
    @objc func searchBarCancelButtonTapped() {
        searchBarCancelButton.isHidden = true
        searchBar.placeholder = "Поиск"
        searchBar.text = ""
        searchBar.endEditing(true)
        reloadVisibleCategroies()
    }
    
    @objc func dismissKeyboard() {
        searchBarCancelButton.isHidden = true
        view.endEditing(true)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = visibleCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerHeaderCollectionView else {
            print("err")
            return UICollectionReusableView()
        }
        let sectionTitle = visibleCategories[indexPath.section]
        section.configSectionTitle(for: sectionTitle)
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reusedIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            print("err")
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        
        cell.delegate = self
        cell.configTracker(for: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, at: indexPath)
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTracker (trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }
}

extension TrackersViewController: TrackerCollectionViewCellProtocol {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        trackerCollectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
        trackerCollectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerSize = CGSize(width: collectionView.bounds.width, height: 19)
        return headerView.systemLayoutSizeFitting(headerSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width / 2 - 20, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        reloadVisibleCategroies()
        
        return true
    }
}



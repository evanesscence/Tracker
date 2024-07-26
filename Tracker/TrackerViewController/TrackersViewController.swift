import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func reloadTrackers()
    func setFilter()
}

class TrackersViewController: UIViewController {
    private let dataManager = DataManager.shared
    private let analyticsService = AnalyticsService()
    
    private var completedTrackers: [TrackerRecord] = []
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var isTomorrow = false
    
    private lazy var searchBar: UISearchTextField = {
        let textField = UISearchTextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var defaultImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TrackersDefault")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var defaultText = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("emptyState", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tBlack
        return label
    }()
    
    private let searchBarContainer = UIStackView()
    private let searchBarCancelButton = UIButton()
    private let addButton = UIButton()
    private let datePickerLabel = UILabel()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("filterButton", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .tBlue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
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
        datePicker.locale = Locale.current
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 77).isActive = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var dateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private lazy var trackerCategoryStore = {
        let trackerCategoryStore = TrackerCategoryStore.shared
        return trackerCategoryStore
    }()
    
    private lazy var trackerRecordStore = {
        let trackerRecordStore = TrackerRecordStore.shared
        return trackerRecordStore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadData()
    }
    
    func setFilter() {
        if UserDefaults.standard.object(forKey: "selectedFilter") as? String == NSLocalizedString("todayTrackers", comment: "") {
            datePicker.date = Date()
            datePickerLabel.text = dateFormatter.string(from: datePicker.date)
            isFiltersModeOn(true)
        }
        
        else if UserDefaults.standard.object(forKey: "selectedFilter") as? String == NSLocalizedString("completedTrackers", comment: "") || UserDefaults.standard.object(forKey: "selectedFilter") as? String == NSLocalizedString("uncompletedTrackers", comment: "") {
            showCompletedTrackers()
            isFiltersModeOn(true)
        }
        
        else {
            isFiltersModeOn(false)
        }
    }
    
    func showCompletedTrackers() {
        visibleCategories = visibleCategories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                var isCompleted = isTrackerCompletedToday(id: tracker.id)
                if UserDefaults.standard.object(forKey: "selectedFilter") as? String == NSLocalizedString("uncompletedTrackers", comment: "") {
                    isCompleted.toggle()
                }
                return isCompleted
            }
            
            if trackers.isEmpty {
                defaultImage.image = UIImage(named: "NotFound")
                defaultText.text = NSLocalizedString("notFound", comment: "")
                
                return nil
            }
            
            return TrackerCategory(
                name: category.name,
                trackers: trackers
            )
        }
    }
    
    private func setupView() {
        setupGeneral()
        setupDefaultInfo()
        setupSearchBar()
        setupAddButton()
        setupDatePickerLabel()
        setupTrackerCollectionView()
        setupFilterButton()
    }
    
    private func setupGeneral() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.leftBarButtonItem?.tintColor = .tBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        title = NSLocalizedString("trackers", comment: "")
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34, weight: .bold), .foregroundColor: UIColor.tBlack]
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func reloadData() {
        let fetchedCategories = trackerCategoryStore.trackers
        categories = fetchedCategories
        completedTrackers = trackerRecordStore.records
        reloadVisibleCategroies()
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
        datePickerLabel.textColor = UIColor.black
        
        view.addSubview(datePicker)
        datePicker.addSubview(datePickerLabel)
        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePickerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            datePickerLabel.heightAnchor.constraint(equalToConstant: 34),
            datePickerLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func isFiltersModeOn(_ mode: Bool) {
        datePickerLabel.backgroundColor = mode ? .tBlue : .tGray
        datePickerLabel.textColor = mode ? .white : .black
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
        
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        searchBar.backgroundColor = .tWhite
        searchBar.clearButtonMode = .never
        searchBar.addTarget(self, action: #selector(searchBarTapped), for: .editingDidBegin)
        
        searchBarCancelButton.isHidden = true
        searchBarCancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
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
        view.addSubview(defaultImage)
        view.addSubview(defaultText)
        
        NSLayoutConstraint.activate([
            defaultImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            defaultImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            defaultImage.widthAnchor.constraint(equalToConstant: 80),
            defaultImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    
        NSLayoutConstraint.activate([
            defaultText.centerXAnchor.constraint(equalTo: defaultImage.centerXAnchor),
            defaultText.topAnchor.constraint(equalTo: defaultImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupTrackerCollectionView() {
        trackerCollectionView.backgroundColor = .tWhite
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
    
    private func setupFilterButton() {
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func reloadVisibleCategroies() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
        let filterDay = calendar.component(.day, from: datePicker.date)
      
        let filterText = (searchBar.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.day.rawValue == filterWeekDay
                }
                
                let currentDay = Calendar.current.dateComponents([.day], from: Date()).day
                let irregularTracker = tracker.schedule.isEmpty ? currentDay : 0
                let irregularTrackerDay = filterDay == irregularTracker
                
                if !textCondition {
                    defaultImage.image = UIImage(named: "NotFound")
                    defaultText.text = NSLocalizedString("notFound", comment: "")
                }
                
                return textCondition && (dateCondition || irregularTrackerDay)
            }
            
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                name: category.name,
                trackers: trackers
            )
        }
        
        setFilter()
        visibleCategories.sort { $0.name == NSLocalizedString("pinnedTracker", comment: "") && $1.name != NSLocalizedString("pinnedTracker", comment: "") }
        trackerCollectionView.reloadData()
        showPlaceholder()
    }
    
    private func showPlaceholder() {
        trackerCollectionView.isHidden = visibleCategories.isEmpty
        filterButton.isHidden = visibleCategories.isEmpty
    }
    
    @objc func datePickerValueChanged() {
        if Date() >= datePicker.date {
            isTomorrow = false
        } else if Date() < datePicker.date {
            isTomorrow = true
        } else {
            isTomorrow = false
        }
        
        if UserDefaults.standard.object(forKey: "selectedFilter") as? String == NSLocalizedString("completedTrackers", comment: "") || UserDefaults.standard.object(forKey: "selectedFilter") as? String == NSLocalizedString("uncompletedTrackers", comment: "") {
            showCompletedTrackers()
        } else {
            UserDefaults.standard.setValue(NSLocalizedString("allTrackers", comment: ""), forKey: "selectedFilter")
            defaultImage.image = UIImage(named: "TrackersDefault")
            defaultText.text = NSLocalizedString("emptyState", comment: "")
        }
        
        datePickerLabel.text = dateFormatter.string(from: datePicker.date)
        reloadVisibleCategroies()
    }
        
    @objc func createNewTracker() {
        analyticsService.report(event: "create_tracker", params: ["test" : categories.count + 1])
        
        let newTracker = NewTrackerController()
        newTracker.delegate = self
        
        present(UINavigationController(rootViewController: newTracker), animated: true, completion: nil)
    }
    
    @objc func textFieldEditingChanged() {
        reloadVisibleCategroies()
    }
    
    @objc func searchBarTapped() {
        searchBarCancelButton.isHidden = false
    }
    
    @objc func searchBarCancelButtonTapped() {
        searchBarCancelButton.isHidden = true
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        searchBar.text = ""
        searchBar.endEditing(true)
        defaultImage.image = UIImage(named: "TrackersDefault")
        defaultText.text = NSLocalizedString("emptyState", comment: "")
        reloadVisibleCategroies()
    }
    
    @objc func dismissKeyboard() {
        searchBarCancelButton.isHidden = true
        view.endEditing(true)
    }
    
    @objc func filterButtonTapped() {
        let trackerFilterViewController = TrackerFilterViewController()
        trackerFilterViewController.delegate = self
        present(UINavigationController(rootViewController: trackerFilterViewController), animated: true)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let section = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerHeaderCollectionView
        else {
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
        
        completedTrackers = trackerRecordStore.records
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        
        cell.delegate = self
        cell.configTracker(for: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, at: indexPath, isTomorrow: isTomorrow)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.section > 0 && indexPath.section == visibleCategories.count - 1) && indexPath.row == visibleCategories[indexPath.section].trackers.count - 1 {
            filterButton.isHidden = true
        }
        else {
            filterButton.isHidden = false
        }
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
        try? trackerRecordStore.addNewTrackerRecord(for: trackerRecord)
        
        completedTrackers = trackerRecordStore.records
        trackerCollectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.forEach { trackerRecord in
            if isSameTracker(trackerRecord: trackerRecord, id: id) {
                try? trackerRecordStore.deleteTrackerRecord(for: trackerRecord)
            }
        }
        
        completedTrackers = trackerRecordStore.records 
        trackerCollectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        
        let preview = TrackerContextMenuPreview(
            color: cell.getColor(),
            emoji: cell.getEmoji(),
            eventInfo: cell.getEventInfo(),
            isPinned: cell.isPinned()
        )
        
        let previewCell = TrackerContextMenuPreviewCell(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 90))
        
        
        let pinTitle = cell.isPinned() ? NSLocalizedString("unpin", comment: "") : NSLocalizedString("pin", comment: "")
        
        let contextMenu = UIContextMenuConfiguration(
            previewProvider: {
                let viewController = UIViewController()
                previewCell.setupCell(for: preview)
                
                viewController.view.addSubview(previewCell)
                viewController.preferredContentSize = CGSize(
                    width: previewCell.frame.width,
                    height: previewCell.frame.height
                )
                
                return viewController
            },
            
            actionProvider: { actions in
                return UIMenu(
                    children: [
                        UIAction(title: pinTitle) { [weak self] _ in
                            guard let self = self else { return }
                            if pinTitle == NSLocalizedString("pin", comment: "") {
                                cell.pinTracker()
                                cell.setupPinnedTracker()
                            } else {
                                cell.unpinTracker()
                                cell.setupUnpinnedTracker()
                            }
                            reloadData()
                        },
                        
                        UIAction(title: NSLocalizedString("edit", comment: "")) { [weak self] _ in
                            guard let self = self else { return }
                            showEditTrackerFlow(for: visibleCategories[indexPath.section].trackers[indexPath.row], with: visibleCategories[indexPath.section].name)
                        },
                        
                        UIAction(title: NSLocalizedString("delete", comment: ""), attributes: .destructive) { [weak self] _ in
                            guard let self = self else { return }
                            let alertModel = AlertModel(
                                title: nil,
                                message: NSLocalizedString("deleteWarning", comment: "")
                            )
                            
                            let alert = Alert().showDeleteAlert(for: alertModel) { [weak self] action in
                                guard let self = self else { return }
                                TrackerStore().delete(tracker: visibleCategories[indexPath.section].trackers[indexPath.row])
                                reloadData()
                            }
                            
                            present(alert, animated: true)
                        }
                    ]
                )
            })
        return contextMenu
    }
    
    private func showEditTrackerFlow(for tracker: Tracker, with category: String) {
        var trackerType = TypeOfEvent.habbit
        
        if !tracker.schedule.isEmpty {
            trackerType = .habbit
        } else {
            trackerType = .irregularEvent
        }
        
        let eventsController = EventsController(type: trackerType, action: .edit)
        eventsController.editingTracker = tracker
        eventsController.trackersVCDelegate = self
        eventsController.editingTrackerCategory = category
        present(UINavigationController(rootViewController: eventsController), animated: true, completion: nil)
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

extension TrackersViewController: TrackersViewControllerDelegate {
    func reloadTrackers() {
        reloadData()
    }
}



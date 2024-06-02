import UIKit

class TrackersViewController: UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var newCategories: [TrackerCategory] = []
    
    private let searchBar = UISearchTextField()
    private let searchBarContainer = UIStackView()
    private let searchBarCancelButton = UIButton()
    
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
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true 
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddButton"), style: .plain, target: self, action: #selector(createNewTracker))
        
        navigationItem.leftBarButtonItem?.tintColor = .tBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        setupDefaultInfo()
        setupSearchBar()
        setupTrackerCollectionView()
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
        trackerCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(trackerCollectionView)
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    @objc func createNewTracker() {
        let newTracker = UINavigationController(rootViewController: NewTrackerController())
        present(newTracker, animated: true, completion: nil)
    }
    
    @objc func searchBarTapped() {
        searchBarCancelButton.isHidden = false
    }
    
    @objc func searchBarCancelButtonTapped() {
        searchBarCancelButton.isHidden = true
        searchBar.placeholder = "Поиск"
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5/*newCategories.count*/
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2/*newCategories[section].trackers.count*/
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reusedIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            print("err")
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerHeaderCollectionView else {
            print("err")
            return UICollectionReusableView()
        }
        return section
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
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



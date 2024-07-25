import UIKit

final class TrackerFilterViewController: UIViewController {
    weak var delegate: TrackersViewControllerDelegate?
    
    private let filters: [String] = [
        NSLocalizedString(
            "allTrackers",
            comment: ""
        ),
        NSLocalizedString(
            "todayTrackers",
            comment: ""
        ),
        NSLocalizedString(
            "completedTrackers",
            comment: ""
        ),
        NSLocalizedString(
            "uncompletedTrackers",
            comment: ""
        )
    ]
    
    private lazy var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TrackerFilterCell.self, forCellReuseIdentifier: TrackerFilterCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = NSLocalizedString("filterButton", comment: "")
        view.backgroundColor = .tWhite
        
        setupFiltersTableView()
    }
    
    private func setupFiltersTableView() {
        view.addSubview(filtersTableView)
        
        filtersTableView.layer.cornerRadius = 16
        filtersTableView.clipsToBounds = true
        filtersTableView.alwaysBounceVertical = false
        filtersTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        filtersTableView.tableHeaderView = UIView()
        
        NSLayoutConstraint.activate([
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            filtersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filtersTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * filters.count))
        ])
    }
}

extension TrackerFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerFilterCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerFilterCell else {
            return UITableViewCell()
        }
        
        if let selectedFilter = UserDefaults.standard.object(forKey: "selectedFilter") as? String {
            if filters[indexPath.row] == selectedFilter {
                cell.isSelected = true
            }
        } else {
            if filters[indexPath.row] == NSLocalizedString("allTrackers", comment: "") {
                cell.isSelected = true
            }
        }
        
        let filterTitle = filters[indexPath.row]
        
        cell.configCell(with: filterTitle)
        setupTheLastCell(cell, at: indexPath)
        
        return cell
    }
    
    private func setupTheLastCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        if indexPath.row == filters.count-1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
    }
}

extension TrackerFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenFilter = filters[indexPath.row]
        UserDefaults.standard.setValue(chosenFilter, forKey: "selectedFilter")
        
        delegate?.setFilter()
        delegate?.reloadTrackers()
        
        dismiss(animated: true)
    }
}


import UIKit

final class TrackerFilterViewController: UIViewController {
    private let filters: [String] = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Незавершенные"]
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
        navigationItem.title = "Фильтры"
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
        
        if let selectedFilter = UserDefaults.standard.object(forKey: "selectedFilter") as? Int {
            if indexPath == IndexPath(row: selectedFilter, section: 0) {
                cell.isSelected = true
            }
        } else {
            if filters[indexPath.row] == "Все трекеры" {
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
        UserDefaults.standard.setValue(indexPath.row, forKey: "selectedFilter")
        dismiss(animated: true)
    }
}


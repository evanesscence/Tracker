import UIKit

struct StatisticsModel {
    let score: Int
    let name: String
}

class StatisticsViewController: UIViewController {
    private let statisticsItems: [StatisticsModel] = [
        StatisticsModel(
            score: 0,
            name: NSLocalizedString("bestPeriod", comment: "")
        ),
        StatisticsModel(
            score: 0,
            name: NSLocalizedString("perfectDays", comment: "")
        ),
        StatisticsModel(
            score: 0,
            name: NSLocalizedString("trackersCompleted", comment: "")
        ),
        StatisticsModel(
            score: 0,
            name: NSLocalizedString("averageValue", comment: "")
        )
    ]
    
    var completedTrackersCount = 0
    
    private lazy var defaultImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StatisticsDefault")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var defaultText = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("statisticsDefaultInfo", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tBlack
        return label
    }()
    
    private lazy var statisticsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGeneral()
    }
    
    private func setupGeneral() {
        title = NSLocalizedString("statistic", comment: "")
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34, weight: .bold), .foregroundColor: UIColor.tBlack]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        statisticsItems.isEmpty ? setupDefaultInfo() : setupStatisticsTableView()
        completedTrackersCount = TrackerRecordStore().records.count
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
    
    private func setupStatisticsTableView() {
        statisticsTableView.isScrollEnabled = false
        statisticsTableView.allowsSelection = false
        statisticsTableView.separatorStyle = .none
        statisticsTableView.backgroundColor = .tWhite
        
        view.addSubview(statisticsTableView)
        statisticsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statisticsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 53),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.reuseIdentifier, for: indexPath) as? StatisticsTableViewCell else {
            return UITableViewCell()
        }
    
        let isCompletedTrackers = statisticsItems[indexPath.row].name == NSLocalizedString("trackersCompleted", comment: "")
        
        let statisticsModel = StatisticsModel(
            score: isCompletedTrackers ? TrackerRecordStore().records.count : 0,
            name: statisticsItems[indexPath.row].name
        )
        
        cell.configStatisticsCell(for: statisticsModel)
    
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}

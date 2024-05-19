import UIKit

class ScheduleController: UIViewController {
    
    private let scheduleTableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private let days = Days.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .tWhite
        
        setupScheduleTableView()
    }
    
    private func setupScheduleTableView() {
        scheduleTableView.tableHeaderView = UIView()
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.alwaysBounceVertical = false
        scheduleTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        scheduleTableView.allowsSelection = false
        
        view.addSubview(scheduleTableView)
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * days.count))
        ])
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
}

extension ScheduleController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            print("err")
            return UITableViewCell()
        }
        
        let dayName = days[indexPath.row].longFormat()
        cell.configCell(for: dayName)
        
        if indexPath.row == days.count-1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
        
        return cell
    }
}

extension ScheduleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}



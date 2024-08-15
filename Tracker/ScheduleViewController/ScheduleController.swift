import UIKit

protocol ScheduleControllerProtocol: AnyObject {
    func didSelectedDays(for day: DaysOfWeek)
}

class ScheduleController: UIViewController {
    
    private var selectedDays: [DaysOfWeek] = []
    weak var delegate: EventsControllerProtocol?
    
    private let scheduleTableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private let confirmButton = UIButton()
    private let days = Days.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Расписание"
        view.backgroundColor = .tWhite
        
        
        setupConfirmButton()
        setupScheduleTableView()
    }
    
    private func setupScheduleTableView() {
        scheduleTableView.tableHeaderView = UIView()
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.clipsToBounds = true
       
     
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
    
    private func setupConfirmButton() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.backgroundColor = .tBlack
        confirmButton.tintColor = .tWhite
        confirmButton.layer.cornerRadius = 16
        confirmButton.setTitle("Готово", for: .normal)
        
        
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func confirmButtonTapped() {
        selectedDays.sort(by: { $0.day.rawValue < $1.day.rawValue })
        delegate?.didConfirm(with: selectedDays)
        dismiss(animated: true)
    }
}

extension ScheduleController: ScheduleControllerProtocol {
    func didSelectedDays(for day: DaysOfWeek) {
        if !selectedDays.contains(where: {$0.day == day.day }) {
            selectedDays.append(day)
        } else {
            selectedDays.removeAll(where: {$0.day == day.day})
        }
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
        
        cell.delegate = self
        
        let dayName = days[indexPath.row]
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



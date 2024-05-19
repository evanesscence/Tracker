import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleTableViewCell"
    private var dayLabel = UILabel()
    private var switchButton = UISwitch()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tLightGray30
        setupUI(for: [dayLabel, switchButton])
        setupDayLabel()
        setupSwitchButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(for dayName: String) {
        dayLabel.text = dayName
    }
    
    private func setupUI(for elements: [UIView]) {
        elements.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupDayLabel() {
        dayLabel.textColor = .tBlack
        dayLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupSwitchButton() {
       
       
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchButton.heightAnchor.constraint(equalToConstant: 31),
            switchButton.widthAnchor.constraint(equalToConstant: 51)
        ])
        
        switchButton.onTintColor = .tBlue
        switchButton.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
    }
    
    
    @objc
    private func changeSwitch() {
        print("j")
    }
}

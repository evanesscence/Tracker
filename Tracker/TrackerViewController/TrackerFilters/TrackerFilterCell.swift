import UIKit

final class TrackerFilterCell: UITableViewCell {
    static let reuseIdentifier = "filterCell"
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private lazy var doneIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setupSelectedCell() : setupDeselectedCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(with title: String) {
        filterLabel.text = title
    }
    
    private func setupUI() {
        backgroundColor = .tLightGray30
        
        setupFilterLabel()
        setupDoneIcon()
    }
    
    private func setupDoneIcon() {
        contentView.addSubview(doneIcon)
        
        NSLayoutConstraint.activate([
            doneIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupFilterLabel() {
        contentView.addSubview(filterLabel)
        
        NSLayoutConstraint.activate([
            filterLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupSelectedCell() {
        doneIcon.image = UIImage(named: "Done")
    }
    
    private func setupDeselectedCell() {
        doneIcon.image = .none
    }
}

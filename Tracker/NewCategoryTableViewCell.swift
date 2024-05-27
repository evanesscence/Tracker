import UIKit

final class NewCategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NewCategoryTableViewCell"
    private let doneIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDoneIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shouldShowDoneIcon() {
        if doneIcon.image == .none {
            doneIcon.image = UIImage(named: "Done")
        } else {
            doneIcon.image = .none
        }
    }
    
    private func setupDoneIcon() {
        contentView.addSubview(doneIcon)
        doneIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

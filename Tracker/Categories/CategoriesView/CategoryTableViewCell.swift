import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NewCategoryTableViewCell"
    private let categoryName = UILabel()
    private let doneIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDoneIcon()
        setupCategoryName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCategoryName() {
        categoryName.textColor = .tBlack
        categoryName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        contentView.addSubview(categoryName)
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    func setCategoryName(_ name: String) {
        categoryName.text = name
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

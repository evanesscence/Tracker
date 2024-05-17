import UIKit

struct TrackerPropertiesModel {
    let title: String
    let image: UIImage
}

class TrackerPropertiesCell: UITableViewCell {
    static let reuseIdentifier = "TrackerPropertiesCell"
    
    private var propertiesLabel = UILabel()
    private var propertiesImage = UIImageView()
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .tLightGray30
        
        addSubview(propertiesLabel)
        addSubview(propertiesImage)
        
        propertiesLabel.translatesAutoresizingMaskIntoConstraints = false
        propertiesImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            propertiesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            propertiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            propertiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            propertiesImage.centerYAnchor.constraint(equalTo: propertiesLabel.centerYAnchor),
            propertiesImage.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configCell(for cell: TrackerPropertiesModel) {
        propertiesLabel.text = cell.title
        propertiesImage.image = cell.image
    }
}

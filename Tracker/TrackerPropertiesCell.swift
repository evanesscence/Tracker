import UIKit

struct TrackerPropertiesModel {
    let title: String
    let image: UIImage
    let selectedDays: String?
}

class TrackerPropertiesCell: UITableViewCell {
    static let reuseIdentifier = "TrackerPropertiesCell"
    
    private var propertiesLabel = UILabel()
    private var chosenPropertiesLabel = UILabel()
    private var propertiesImage = UIImageView()
    private var propertiesContainer = UIStackView()
        
    
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
        addSubview(chosenPropertiesLabel)
        addSubview(propertiesImage)
        addSubview(propertiesContainer)
        
        setupPropertiesContainer(for: [propertiesLabel, chosenPropertiesLabel])
        setupSystemFont(for: [propertiesLabel, chosenPropertiesLabel])
        
        propertiesLabel.translatesAutoresizingMaskIntoConstraints = false
        chosenPropertiesLabel.translatesAutoresizingMaskIntoConstraints = false
        propertiesImage.translatesAutoresizingMaskIntoConstraints = false
        propertiesContainer.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            propertiesContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            propertiesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            propertiesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56),
    
        ])
        
        NSLayoutConstraint.activate([
            propertiesImage.centerYAnchor.constraint(equalTo: propertiesContainer.centerYAnchor),
            propertiesImage.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupPropertiesContainer(for properties: [UIView]) {
        propertiesContainer.axis = .vertical
        propertiesContainer.spacing = 2
        
        properties.forEach {
            propertiesContainer.addArrangedSubview($0)
        }
    }
    
    private func setupSystemFont(for labels: [UILabel]) {
        labels.forEach {
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
    }
    
    func configCell(for cell: TrackerPropertiesModel) {
        if cell.title == Properties.sсhedule.rawValue {
            chosenPropertiesLabel.text = cell.selectedDays
        }
       
      
        propertiesLabel.text = cell.title
        chosenPropertiesLabel.textColor = .tTextFieldLabel
        propertiesImage.image = cell.image
    }
}

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let reusedIdentifier = "TrackerCollectionViewCell"
    
    private var background = UIView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.widthAnchor.constraint(equalToConstant: 20),
            background.heightAnchor.constraint(equalToConstant: 20),
            background.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            background.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]) 
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell() {
        background.backgroundColor = .yellow
        background.layer.cornerRadius = 16
    }
}

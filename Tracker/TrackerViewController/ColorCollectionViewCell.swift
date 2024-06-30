import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    static let reusedIdentifier = "ColorCollectionViewCell"
    
    private let colorView = UIView()
    private let label = UILabel()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setupSelectedCell() : setupDeselectedCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    
    }
    
    func configCell(with color: String) {
        colorView.backgroundColor = UIColor(hexString: color)
        
    }
    
    private func setupSelectedCell() {
        layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    private func setupDeselectedCell() {
        layer.borderWidth = 0
        layer.borderColor = .none
    }
    private func setupColorView() {
        colorView.frame.size = CGSize(width: 40, height: 40)
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 46),
            colorView.widthAnchor.constraint(equalToConstant: 46),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

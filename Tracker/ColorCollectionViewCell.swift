import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    static let reusedIdentifier = "ColorCollectionViewCell"
    
    private let colorView = UIView()
    private let label = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    
    }
    
    func configCell(with color: String) {
        colorView.backgroundColor = UIColor(hexString: color)
        
    }
    
    private func setupColorView() {

        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

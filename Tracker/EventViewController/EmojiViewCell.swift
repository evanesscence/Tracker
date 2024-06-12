import UIKit

class EmojiViewCell: UICollectionViewCell {
    let emoji = UILabel()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setupSelectedCell() : setupDeselectedCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupSelectedCell() {
        backgroundColor = UIColor.tLightGray1
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    private func setupDeselectedCell() {
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

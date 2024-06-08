import UIKit

class EmojiViewCell: UICollectionViewCell {
    let emoji = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

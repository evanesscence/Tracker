import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let reusedIdentifier = "TrackerCollectionViewCell"
    
    var background = UIView()
    var emoji = UILabel()
    var emojiView = UIView()
    var eventInfo = UILabel()

    var daysCount = UILabel()
    var completeButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(background)
        contentView.addSubview(daysCount)
        contentView.addSubview(completeButton)
        
        background.addSubview(emojiView)
        background.addSubview(eventInfo)
        emojiView.addSubview(emoji)
    
        
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        background.translatesAutoresizingMaskIntoConstraints = false
        eventInfo.translatesAutoresizingMaskIntoConstraints = false
        daysCount.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.topAnchor.constraint(equalTo: background.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            eventInfo.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 12),
            eventInfo.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12),
            eventInfo.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -12),
        ])
        
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
        
       
        
        NSLayoutConstraint.activate([
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            daysCount.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 16),
            daysCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
           
        ])
        
        background.backgroundColor = .purple
        background.layer.cornerRadius = 16
        background.layer.masksToBounds = true
        
        emojiView.backgroundColor = .tWhite30
        emojiView.frame.size = CGSize(width: 24, height: 24)
        emojiView.layer.cornerRadius = emojiView.frame.size.width / 2
        emojiView.layer.masksToBounds = true
        
        emoji.text = "🌺"
        emoji.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        eventInfo.text = "Бабушка прислала открытку в вотсапе"
        eventInfo.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        eventInfo.textColor = .tWhite
        eventInfo.numberOfLines = 2
       
        
        daysCount.text = "1 день"
        daysCount.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        daysCount.textColor = .tBlack
    
        
        let completeButtonConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .large)
        let completeButtonImage = UIImage(systemName: "plus", withConfiguration: completeButtonConfig)
        
        completeButton.setImage(completeButtonImage, for: .normal)
        completeButton.tintColor = .tWhite
        completeButton.backgroundColor = .systemPink
        completeButton.frame.size = CGSize(width: 34, height: 34)
        completeButton.layer.cornerRadius = completeButton.frame.width / 2
        completeButton.layer.masksToBounds = true
    }
    
    func configTracker(for cell: Tracker) {
        background.backgroundColor = cell.color
        completeButton.backgroundColor = cell.color
        emoji.text = cell.emoji
        eventInfo.text = cell.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

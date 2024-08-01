import UIKit

struct TrackerContextMenuPreview {
    let color: UIColor
    let emoji: String
    let eventInfo: String
    let isPinned: Bool
}

final class TrackerContextMenuPreviewCell: UICollectionViewCell {
    private var background = UIView()
    private var emoji = UILabel()
    private var emojiView = UIView()
    private var eventInfo = UILabel()
    private var pin = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupCell(for model: TrackerContextMenuPreview) {
        background.backgroundColor = model.color
        emoji.text = model.emoji
        eventInfo.text = model.eventInfo
        
        if model.isPinned {
            pinTracker()
        }
    }
    
    private func pinTracker() {
        pin.image = UIImage(named: "Pin")
    }
    
    private func setupUI() {
        addSubviews()
        resetConstraints()
        setupConstraits()
        setupViews()
    }
    
    private func addSubviews() {
        contentView.addSubview(background)
        
        background.addSubview(emojiView)
        background.addSubview(eventInfo)
        background.addSubview(pin)
        emojiView.addSubview(emoji)
    }
    
    private func resetConstraints() {
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        background.translatesAutoresizingMaskIntoConstraints = false
        eventInfo.translatesAutoresizingMaskIntoConstraints = false
        pin.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraits() {
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
            pin.topAnchor.constraint(equalTo: background.topAnchor, constant: 12),
            pin.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -4),
            pin.heightAnchor.constraint(equalToConstant: 24),
            pin.widthAnchor.constraint(equalToConstant: 24)
         
        ])
    }
    
    private func setupViews() {
        background.backgroundColor = .purple
        background.layer.cornerRadius = 16
        background.layer.masksToBounds = true
        
        emojiView.backgroundColor = .tWhite30
        emojiView.frame.size = CGSize(width: 24, height: 24)
        emojiView.layer.cornerRadius = emojiView.frame.size.width / 2
        emojiView.layer.masksToBounds = true
        
        emoji.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        eventInfo.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        eventInfo.textColor = .tWhite
        eventInfo.numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

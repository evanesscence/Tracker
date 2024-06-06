import UIKit

protocol TrackerCollectionViewCellProtocol: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let reusedIdentifier = "TrackerCollectionViewCell"
    
    weak var delegate: TrackerCollectionViewCellProtocol?
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    var background = UIView()
    var emoji = UILabel()
    var emojiView = UIView()
    var eventInfo = UILabel()

    var daysCount = UILabel()
    var completeButton = UIButton()
    
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    private let doneImage = UIImage(named: "DoneButton")
    
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
       
        daysCount.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        daysCount.textColor = .tBlack
    
        setupCompleteButton()
    }
    
    func configTracker(for cell: Tracker, isCompletedToday: Bool, completedDays: Int, at indexPath: IndexPath) {
        trackerId = cell.id
        self.indexPath = indexPath
        self.isCompletedToday = isCompletedToday
        
        background.backgroundColor = cell.color
        completeButton.backgroundColor = cell.color
        emoji.text = cell.emoji
        eventInfo.text = cell.name
        
        if !cell.schedule.isEmpty {
            daysCount.text = wordDay(for: completedDays)
        } else {
            daysCount.text = "Только сегодня"
        }
        
        
        let image = isCompletedToday ? doneImage : plusImage
        let opacity = isCompletedToday ? 0.3 : 1
        
        completeButton.layer.opacity = Float(opacity)
        completeButton.setImage(image, for: .normal)
    }
    
    func setupCompleteButton() {
        completeButton.tintColor = .tWhite
        completeButton.backgroundColor = .systemPink
        completeButton.frame.size = CGSize(width: 34, height: 34)
        completeButton.layer.cornerRadius = completeButton.frame.width / 2
        completeButton.layer.masksToBounds = true
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func wordDay(for number: Int) -> String {
        var word = "\(number) "
        switch number {
        case 1, 21, 31:
            word += "день"
            break
        case 2, 3, 4, 22, 23, 24:
            word += "дня"
            break
        default:
            word += "дней"
            break
        }
        
        return word
    }
    
    @objc
    private func completeButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else { return }
        isCompletedToday ? delegate?.uncompleteTracker(id: trackerId, at: indexPath) : delegate?.completeTracker(id: trackerId, at: indexPath)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit

final class TrackerHeaderCollectionView: UICollectionReusableView {
    private let categoryName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoryName.text = "Радостные мелочи"
        categoryName.textColor = .tBlack
        categoryName.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        addSubview(categoryName)
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryName.topAnchor.constraint(equalTo: topAnchor),
            categoryName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            categoryName.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configSectionTitle(for header: TrackerCategory) {
        categoryName.text = header.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

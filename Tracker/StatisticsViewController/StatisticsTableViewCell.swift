import UIKit

class GradientBorderView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Настройка градиентного слоя
        gradientLayer.colors = [UIColor.gRed.cgColor, UIColor.gGreenBlue.cgColor, UIColor.gBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)

        // Настройка слоя формы для границы
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
    }
}


final class StatisticsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsTableViewCell"
    
    private let statisticsView = {
        let view = GradientBorderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let statiscticsStackView = UIStackView()
    
    private let statisticsScore = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.tBlack
        
        return label
    }()
    
    private let statisticsName = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.tBlack
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func configStatisticsCell(for model: StatisticsModel) {
        statisticsName.text = model.name
        statisticsScore.text = String(model.score)
    }
    
    private func setupUI() {
        backgroundColor = .tWhite
    
        setupStatisticsView()
        setupStatisticsStackView()
    }
    
    private func setupStatisticsView() {
        contentView.addSubview(statisticsView)
        
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            statisticsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statisticsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statisticsView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupStatisticsStackView() {
        statisticsView.addSubview(statiscticsStackView)
        statiscticsStackView.addArrangedSubview(statisticsScore)
        statiscticsStackView.addArrangedSubview(statisticsName)

        statiscticsStackView.translatesAutoresizingMaskIntoConstraints = false
        statiscticsStackView.backgroundColor = .tWhite
        statiscticsStackView.axis = .vertical
        statiscticsStackView.spacing = 7
        
        NSLayoutConstraint.activate([
            statiscticsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            statiscticsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            statiscticsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


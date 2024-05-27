import UIKit

final class DarkButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        createButton(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(title: String) {
        backgroundColor = .tBlack
        tintColor = .tWhite
        layer.cornerRadius = 16
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

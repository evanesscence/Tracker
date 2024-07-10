import UIKit

final class PageViewController: UIViewController {
    private let pageImageName: String
    private let pageDescription: String
    
    init(pageImageName: String, pageDescription: String) {
        self.pageImageName = pageImageName
        self.pageDescription = pageDescription
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let preview: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "FirstPage")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        return imageView
    }()
    
    private let previewDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
    
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.tintColor = .tBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let startButton: DarkButton = {
        let button = DarkButton(title: "Вот это технологии!")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        let views = [preview, startButton, previewDescription]
        views.forEach {
            view.addSubview($0)
        }
        
        setupPreview()
        setupStartButton()
        setupPreviewDescription()
    }
    
    private func setupPreview() {
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: view.topAnchor),
            preview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            preview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupStartButton() {
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupPreviewDescription() {
        previewDescription.text = pageDescription
        
        NSLayoutConstraint.activate([
            previewDescription.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -160),
            previewDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            previewDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}

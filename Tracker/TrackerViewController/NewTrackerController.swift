import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func reloadTrackers()
}

class NewTrackerController: UIViewController {
    weak var delegate: TrackersViewControllerDelegate?
    private let habbitButton = UIButton()
    private let irregularEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tWhite
        navigationItem.title = NSLocalizedString("createTracker", comment: "")
        
        buttonsConfig([habbitButton, irregularEventButton])
        habbitButtonConfig()
        irregularEventConfig()
    }
    
    private func buttonsConfig(_ buttons: [UIButton]) {
        buttons.forEach { button in
            button.backgroundColor = .tBlack
            button.setTitleColor(.tWhite, for: .normal)
            button.layer.cornerRadius = 16
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
    private func habbitButtonConfig() {
        habbitButton.setTitle(NSLocalizedString("habbit", comment: ""), for: .normal)
        habbitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        habbitButton.addTarget(self, action: #selector(addHabbit), for: .touchUpInside)
    }
    
    private func irregularEventConfig() {
        irregularEventButton.setTitle(NSLocalizedString("irregularEvent", comment: ""), for: .normal)
        irregularEventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16).isActive = true
        
        irregularEventButton.addTarget(self, action: #selector(addIrregularEvent), for: .touchUpInside)
    }
    
    @objc private func addHabbit() {
        let eventsController = EventsController(type: .habbit, action: nil)
        eventsController.delegate = self
        present(UINavigationController(rootViewController: eventsController), animated: true, completion: nil)
    }
    
    @objc private func addIrregularEvent() {
        let eventsController = EventsController(type: .irregularEvent, action: nil)
        eventsController.delegate = self
        present(UINavigationController(rootViewController: eventsController), animated: true, completion: nil)
    }
}

extension NewTrackerController: NewTrackerViewControllerDelegate {
    func reloadTrackers() {
        delegate?.reloadTrackers()
    }
}

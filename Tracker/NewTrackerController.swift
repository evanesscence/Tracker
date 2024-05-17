import UIKit

class NewTrackerController: UIViewController {
    private let habbitButton = UIButton()
    private let irregularEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Создание трекера"
        
        buttonsConfig([habbitButton, irregularEventButton])
        habbitButtonConfig()
        irregularEventConfig()
    }
    
    private func buttonsConfig(_ buttons: [UIButton]) {
        buttons.forEach { button in
            button.backgroundColor = .tBlack
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
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        habbitButton.addTarget(self, action: #selector(addHabbit), for: .touchUpInside)
    }
    
    private func irregularEventConfig() {
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16).isActive = true
        
        irregularEventButton.addTarget(self, action: #selector(addIrregularEvent), for: .touchUpInside)
    }
    
    @objc private func addHabbit() {
        let eventsController = UINavigationController(rootViewController: EventsController(type: .habbit))
        present(eventsController, animated: true, completion: nil)
    }
    
    @objc private func addIrregularEvent() {
        let eventsController = UINavigationController(rootViewController: EventsController(type: .irregularEvent))
        present(eventsController, animated: true, completion: nil)
    }
}

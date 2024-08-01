import UIKit

class TabBarController: UITabBarController {
    private lazy var trackersTabBarItemTitle = {
        let title = NSLocalizedString("trackers", comment: "")
        return title
    }()
    
    private lazy var statisticTabBarItemTitle = {
        let title = NSLocalizedString("statistic", comment: "")
        return title
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tWhite
        tabBar.backgroundColor = .tWhite
        tabBar.tintColor = .tBlue
        setUpperLine()
                
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController()) 
        
        trackersViewController.tabBarItem = UITabBarItem(title: trackersTabBarItemTitle, image: UIImage(named: "TrackersTabBar"), selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(title: statisticTabBarItemTitle, image: UIImage(named: "StatisticsTabBar"), selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setUpperLine () {
        let upperLine = UIView()
        upperLine.backgroundColor = .tTextFieldLabel
        upperLine.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(upperLine)
        
        NSLayoutConstraint.activate([
            upperLine.heightAnchor.constraint(equalToConstant: 0.5),
            upperLine.topAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor, constant: 0),
            upperLine.leadingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            upperLine.trailingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}


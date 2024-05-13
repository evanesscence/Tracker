import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tWhite
        tabBar.backgroundColor = .tWhite
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.tintColor = .tBlue
                
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController()) 
        
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackersTabBar"), selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticsTabBar"), selectedImage: nil)
        
        
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
}


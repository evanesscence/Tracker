import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tWhite
        tabBar.tintColor = .tBlue
                
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackersTabBar"), selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticsTabBar"), selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
}


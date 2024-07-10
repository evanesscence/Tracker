import UIKit

final class OnboardingViewController: UIPageViewController {
    private lazy var pages: [PageViewController] = {
        let firstPage = PageViewController(pageImageName: "FirstPage", pageDescription: "Отслеживайте только то, что хотите")
        let secondPage = PageViewController(pageImageName: "SecondPage", pageDescription: "Даже если это не литры воды и йога")
        
        return [firstPage, secondPage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true
            )
        }
    }
}

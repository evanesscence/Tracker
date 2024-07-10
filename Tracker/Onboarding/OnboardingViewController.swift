import UIKit

final class OnboardingViewController: UIPageViewController {
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pages: [PageViewController] = {
        let firstPage = PageViewController(pageImageName: "FirstPage", pageDescription: "Отслеживайте только то, что хотите")
        let secondPage = PageViewController(pageImageName: "SecondPage", pageDescription: "Даже если это не литры воды и йога")
        
        return [firstPage, secondPage]
    }()
    
    private lazy var pageIndicator: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .tBlack
        pageControl.pageIndicatorTintColor = .tBlack30
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shownOnboardingOrTrackerController()
    }
    
    private func shownOnboardingOrTrackerController() {
        guard let _ = UserDefaults.standard.object(forKey: "isReEntry") else {
            setupView()
            return
        }
        
        guard let window = UIApplication.shared.windows.first else { return }
        let mainScreen = TabBarController()
        window.rootViewController = mainScreen
    }
    
    private func setupView() {
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true
            )
        }
        
        view.addSubview(pageIndicator)
        setupPageIndicator()
    }
    
    private func setupPageIndicator() {
        NSLayoutConstraint.activate([
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard 
            let page = viewController as? PageViewController,
            let index = pages.firstIndex(of: page)
        else { return nil }
        
        let previousIndex = index - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let page = viewController as? PageViewController,
            let index = pages.firstIndex(of: page)
        else { return nil }
        
        let nextPage = index + 1
        guard nextPage < pages.count else {
            return nil
        }
        return pages[nextPage]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first as? PageViewController {
            guard let currentindex = pages.firstIndex(of: currentViewController) else { return }
            pageIndicator.currentPage = currentindex
        }
    }
}

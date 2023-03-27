//
//  WelcomePageViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/21.
//

import SnapKit

final class WelcomePageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let firstWelcomeViewController = FirstWelcomeViewController()
    private let secondWelcomeViewController = SecondWelcomeViewController()
        
    private var subViewControllers: [UIViewController] = []

    
    private var currentPage: Int?
      
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal)
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setupSubViewControllers()
        pageViewController.didMove(toParent: self)
        setupLayout()
        setFirstViewController()
    }
    
    // MARK: - Helpers

    
    private func setupSubViewControllers() {
        firstWelcomeViewController.delegate = self
        secondWelcomeViewController.delegate = self
        subViewControllers.append(firstWelcomeViewController)
        subViewControllers.append(secondWelcomeViewController)
    }
    
    private func setupLayout(){

        self.addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    
    private func setFirstViewController() {
        if let firstVC = subViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

}


// MARK: - PageViewController Delegate
extension WelcomePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return subViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil}
        let afterIndex = index + 1
        if afterIndex == subViewControllers.count {
            return nil
        }
        return subViewControllers[afterIndex]
        
    }


}

extension WelcomePageViewController: FirstNextButtonTappedDelegate {
    func moveToNextPage() {
        pageViewController.setViewControllers([self.subViewControllers[1]], direction: .forward, animated: true)
    }
}

extension WelcomePageViewController: SecondNextButtonTappedDelegate {
    func moveToMain() {
        let loginVC = LoginViewController()
        show(loginVC, sender: self)
    }
}

//
//  WelcomePageViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/21.
//

import UIKit
import SnapKit

class WelcomePageViewController: UIPageViewController {
    
    // MARK: - Properties
    

    private var subViewControllers: [UIViewController] = [FirstWelcomeViewController(), SecondWelcomeViewController()]

    private var currentPage: Int?
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal)
        pageVC.view.backgroundColor = .white
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.frame.maxY-30, width: self.view.frame.maxX, height: 10))
        pageControl.backgroundColor = .white
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.currentPage = 0
        return pageControl
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        self.setupLayout()
    }
    
    
    
    // MARK: - Helpers
    
    private func addActionToButton() {
        let firstWelcomeViewController = FirstWelcomeViewController()
        firstWelcomeViewController.firstView.nextPageButton.setOpaqueTapGestureRecognizer {
//            if nowIdx < 3{
//                       pageInstance?.setViewControllers([(pageInstance?.VCArray[nowIdx+1])!], direction: .forward,
//                       animated: true, completion: nil)
//
//                   }
        }
    }
    
    private func setupLayout(){
        self.addChild(pageViewController)
        view.addSubview(pageViewController.view)
        self.view.addSubview(pageControl)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    private func setPageControl() {
        DispatchQueue.main.async {
            self.pageControl.setIndicatorImage(UIImage(systemName: "circlebadge.fill"), forPage: 0)
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

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = subViewControllers.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
        self.pageControl.currentPage = currentIndex

    }
}

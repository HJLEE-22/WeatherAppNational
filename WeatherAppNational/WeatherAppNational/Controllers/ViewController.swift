//
//  ViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//



import UIKit

class ViewController: UIViewController {

    // MARK: - properties
    
//    var nowWeather: WeatherData?

    lazy var listButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(listButtonTapped))
        return btn
    }()
    
    
    lazy var settingButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingButtonTapped))
        return btn
    }()
    
    
    let firstVC = FirstViewController()
    
    let secondVC = SecondViewController()
    
    let todayWeatherView = TodayWeatherView()
    
    var activeVCs = [FirstViewController.self, SecondViewController.self]
    
    var chosenId = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageVC()
//        setupPageControll()
        setupNav()
        setupData()
    }

    
    
    
    // MARK: - Helpers
    
    func setupData() {
//        TodayWeatherDataManager.shared.fetchWeatherByName(city: "서울", county: "강남구", village: "도곡동") { result in
//            print(#function)
//            switch result {
//            case .success(let weatherData) :
//                self.nowWeather = weatherData
//                print("DEBUG : \(weatherData)")
//
//                print("DEBUG : \(self.nowWeather)")
//            case .failure(let error) :
//                print("DEBUG: \(error.localizedDescription)")
//            }
//
//        }
    }

    
    func setupNav() {
        
        navigationItem.title = "현재 위치"
        navigationController?.navigationBar.tintColor = .purple
        navigationItem.rightBarButtonItem = listButton
        navigationItem.leftBarButtonItem = settingButton
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
    
    func initPageVC() {
        
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(pageVC.view)
        addChild(pageVC)
        pageVC.dataSource = self
        pageVC.delegate = self
        
        
        let viewControllers = [FirstViewController()]
        pageVC.setViewControllers(viewControllers, direction: .reverse, animated: true)
        
    }
    
    
    func setupPageControll() {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .systemBlue

        
    }
    

    // MARK: - Actions
    
    @objc func listButtonTapped() {
        show(CitiesViewController(), sender: self)
        
    }
    
//    @objc func settingButtonTapped() {
//        show(SettingViewController(), sender: self)
//        navigationController?.pushViewController(SettingViewController(), animated: true)
//
//    }
    
    @objc func settingButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
}


extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController as? FirstViewController != nil {
            return nil
        }
        return FirstViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController as? SecondViewController != nil {
            return nil
        }
        return SecondViewController()
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return activeVCs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return chosenId
    }
    
    
}


extension ViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?[0] as? FirstViewController {
                
            }
        }
    }
    
    
}


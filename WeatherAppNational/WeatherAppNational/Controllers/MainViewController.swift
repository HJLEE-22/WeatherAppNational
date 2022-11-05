//
//  MainViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//



import UIKit
import CoreLocation

class MainViewController: UIViewController {

    private var subViewControllers: [UIViewController] = []
    var currentPage: Int = 0 {
        didSet {
            bind(oldValue: oldValue, newValue: currentPage)
        }
    }
    
    // 위치정보 변수
    var locationManager = CLLocationManager()
    
    lazy var listButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(listButtonTapped))
        return btn
    }()
    
    
    lazy var settingButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingButtonTapped))
        return btn
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.view.backgroundColor = .clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupNav()
        
        pageViewController.didMove(toParent: self)
        setupViewControllers()
        setViewControllersInPageVC()
        
        checkUserDeviceLocationServiceAuthorization()

    }

    func layout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func setupNav() {
        navigationItem.title = "현재 위치"
        navigationController?.navigationBar.tintColor = .purple
        navigationItem.rightBarButtonItem = listButton
        navigationItem.leftBarButtonItem = settingButton
        let backBarButtonItem = UIBarButtonItem(title: "",
                                                style: .plain,
                                                target: self,
                                                action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
    func setupPageControll() {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .systemBlue
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
        locationManager.delegate = self
        // 3.1
        guard CLLocationManager.locationServicesEnabled() else {
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            return
        }
        
        // 3.2
        let authorizationStatus: CLAuthorizationStatus
            
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
            
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }

    // 시스템 설정으로 유도하는 커스텀 얼럿
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용",
                                                            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
                                                            preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동",
                                      style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소",
                                   style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
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
        navigationController?.view.layer.add(transition,
                                             forKey: kCATransition)
        self.navigationController?.pushViewController(SettingViewController(),
                                                      animated: true)
    }
    
}

extension MainViewController {
    
    private func setupViewControllers() {
        if let cities = UserDefaultsUtil.shared.getCities() {
            cities.forEach { city in
                let vc = WeatherViewController()
                vc.viewModel = .init(name: city.name, nx: city.nx, ny: city.ny)
                subViewControllers.append(vc)
            }
        } else {
            let vc = WeatherViewController()
            vc.viewModel = .init(name: "서울특별시", nx: 60, ny: 127)
            
            let vc2 = WeatherViewController()
            vc2.viewModel = .init(name: "부산광역시", nx: 98, ny: 76)
            
            subViewControllers.append(vc)
            subViewControllers.append(vc2)
        }
        currentPage = 0
    }
    
    private func setViewControllersInPageVC() {
        if let firstVC = subViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func bind(oldValue: Int, newValue: Int) {
        let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
        pageViewController.setViewControllers([subViewControllers[currentPage]], direction: direction, animated: false, completion: nil)
    }
}


extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DidUpdateLocation")
        
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
        if let coordinate = locations.last?.coordinate {
            // ⭐️ 사용자 위치 정보 사용
            print("DEBUG: 위도 \(coordinate.latitude)")
            print("DEBUG: 경도 \(coordinate.longitude)")
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            let convertedGrid = ConvertGPS.convertGRIDtoGPS(mode: TO_GRID, lat_X: lat, lng_Y: lon)
//            self.nxForLoaction = String(convertedGrid.x)
//            self.nyForLocation = String(convertedGrid.y)
            print("DEBUG: convertedGrid \(convertedGrid.x), \(convertedGrid.y)")
        }
        
        // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
        // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension MainViewController: UpdatingLocationButtonDelegate {
    func updatingLocationButtonTapped() {
        print("DEBUG: check for location button ")

        if locationManager.allowsBackgroundLocationUpdates {
            print("DEBUG: update to allow for location ")
            locationManager.stopUpdatingLocation()
        } else {
            print("DEBUG: update to reject for location")
            locationManager.startUpdatingLocation()
        }
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return subViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == subViewControllers.count {
            return nil
        }
        return subViewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = subViewControllers.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
    }
}

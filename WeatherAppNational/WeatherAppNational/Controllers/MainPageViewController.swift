//
//  MainPageViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//



import UIKit
import CoreLocation

final class MainPageViewController: UIViewController {

// MARK: - properties
    
    
    private let geocoder = CLGeocoder()
    private let locale = Locale(identifier: "ko-kr")
    private var currentAdministrativeName: String?
    private var currentCityName: String?
//    var userViewModel: UserViewModel! {
//        didSet {
//            userViewModel.subscribe(observer: self)
//        }
//    }
    
    private var subViewControllers: [UIViewController] = [] {
        didSet {
            self.setPageControlForCurrentLocation()
        }
    }
    
    private var currentPage: Int?{
        didSet {
            guard let currentPage = currentPage else { return }
            bind(oldValue: oldValue ?? 0, newValue: currentPage)
        }
    }

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    private lazy var listButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: SystemIconNames.listDash), style: .plain, target: self, action: #selector(listButtonTapped))
        return btn
    }()
    
    private lazy var settingButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: SystemIconNames.gearShape), style: .plain, target: self, action: #selector(settingButtonTapped))
        return btn
    }()

    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal)
        pageVC.view.backgroundColor = .white
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()

    private var convertedGridX: Int?
    private var convertedGridY: Int?
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.frame.maxY-30, width: self.view.frame.maxX, height: 10))
        pageControl.backgroundColor = .white
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.currentPage = 0
        return pageControl
    }()
    
    private let bulletionBoardViewController = BulletinBoardViewController()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        pageViewController.didMove(toParent: self)
        locationManager.delegate = self
        checkLocationServiceAuthorizationByVersion(self.locationManager)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewControllersForBookmarked(city: nil, area: nil)
    }
    
    
    // MARK: - Helpers

    
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
    
    private func setupNav() {

        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = listButton
        navigationItem.leftBarButtonItem = settingButton
        let backBarButtonItem = UIBarButtonItem(title: "",
                                                style: .plain,
                                                target: self,
                                                action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray3
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: AppFontName.bold, size: 20)!]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
    }
    

    
    private func checkLocationServiceAuthorizationByVersion(_ locationManager: CLLocationManager) {
            
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                // 여기서 위치권한이 있을때 실행할 코드 입력
                locationManager.startUpdatingLocation()
            } else {
                // 여기서 위치권환 off일때 실행할 코드 입력
//                if UserDefaults.standard.bool(forKey: UserDefaultsKeys.launchedBefore) == false {
                    switchUserCurrentLocationAuthorization(locationManager.authorizationStatus)
//                }
                self.convertedGridX = nil
                self.convertedGridY = nil
                self.currentLatitude = nil
                self.currentLongitude = nil
            }
        } else {
            guard CLLocationManager.locationServicesEnabled() else {
                // 시스템 설정으로 유도하는 커스텀 얼럿
                switchUserCurrentLocationAuthorization(CLLocationManager.authorizationStatus())
                return
            }
        }
    }
    
    private func switchUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            self.setupLayout()
            self.setupViewControllersForBookmarked(city: nil, area: nil)
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }

    // 시스템 설정으로 유도하는 커스텀 얼럿
    private func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
    private func setPageControlForCurrentLocation() {
        DispatchQueue.main.async {
            if self.currentLatitude != nil && self.subViewControllers != [] {
                self.pageControl.setIndicatorImage(UIImage(systemName: SystemIconNames.gpsOn), forPage: 0)
            } else if self.subViewControllers != [] {
                self.pageControl.setIndicatorImage(UIImage(systemName: "circlebadge.fill"), forPage: 0)
            }
        }
    }

    // MARK: - Actions
    
    
    private func addActionBulletinBoardViewOpen(_ weatherVC: WeatherViewController) {
        weatherVC.mainView.todayWeatherView.imageViewforTouch.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self else { return }
            self.show(self.bulletionBoardViewController, sender: self)
            self.bulletionBoardViewController.navigationItem.title = weatherVC.weatherKitViewModel.name
            self.bulletionBoardViewController.backgroundGradientLayer = weatherVC.mainView.todayWeatherView.backgroundGradientLayer
        }
    }
    
    @objc private func listButtonTapped() {
        show(CitiesViewController(), sender: self)
    }
    
    @objc private func settingButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        show(SettingViewController(), sender: self)
    }
}

// MARK: - Set VCs in PageVC
extension MainPageViewController {
   
    private func setupViewControllersForBookmarked(city: String?, area: String?){

        subViewControllers.removeAll()
        
        // 현재 위치에 따른 첫 번째 날씨 페이지 로드
        // 조건문 분기는, geocoder를 사용해 나눌땐 위치정보(도시이름)을 인자로 바로 받아 사용
        // 두 번째 분기는, 그렇게 받아진 걸 변수로 저장해 변수를 불러와 사용... 그 외에 내용이 모두 중복됨.
        // 즉, 첫번째 분기는 정리할 필요 있음.
        if let currentLatitude,
           let currentLongitude,
           let city, let area,
           let gridX = convertedGridX,
           let gridY = convertedGridY {
            let vc = WeatherViewController()
            self.addActionBulletinBoardViewOpen(vc)
            vc.weatherKitViewModel = .init(name: "\(area) \(city)",
                                           latitude: currentLatitude,
                                           longitude: currentLongitude,
                                           gridX: gridX,
                                           gridY: gridY)
            vc.mainView.todayWeatherView.buttonDelegate = self
            self.navigationItem.title = vc.weatherKitViewModel.name
            subViewControllers.append(vc)
            self.pageControl.numberOfPages = subViewControllers.count
            setupFisrtViewController()
        } else if let currentLatitude,
                  let currentLongitude,
                  let currentAdministrativeName,
                  let currentCityName,
                  let gridX = convertedGridX,
                  let gridY = convertedGridY {
            let vc = WeatherViewController()
            self.addActionBulletinBoardViewOpen(vc)
            vc.weatherKitViewModel = .init(name: "\(currentAdministrativeName) \(currentCityName)",
                                           latitude: currentLatitude,
                                           longitude: currentLongitude,
                                           gridX: gridX,
                                           gridY: gridY)
            vc.mainView.todayWeatherView.buttonDelegate = self
            self.navigationItem.title = vc.weatherKitViewModel.name
            subViewControllers.append(vc)
            self.pageControl.numberOfPages = subViewControllers.count
            setupFisrtViewController()
        }
        
        // 북마크 추가된 날씨 페이지 로드
        let cities = CoreDataManager.shared.getBookmarkedLocationGridList()
        cities.forEach(){ location in
            let vc = WeatherViewController()
            guard let city = location.city,
                  let district = location.district else { return }
            let locationName = "\(city) \(district)"
            self.addActionBulletinBoardViewOpen(vc)
            let locationGridX = Int(location.gridX)
            let locationGridY = Int(location.gridY)
            vc.weatherKitViewModel = .init(name: locationName, latitude: location.latitude, longitude: location.longitude, gridX: locationGridX, gridY: locationGridY)
            vc.mainView.todayWeatherView.buttonDelegate = self
            self.navigationItem.title = vc.weatherKitViewModel.name
            subViewControllers.append(vc)
            self.pageControl.numberOfPages = subViewControllers.count
            
            setupFisrtViewController()
        }
            currentPage = 0
    }
    
    private func setupFisrtViewController() {
        if let firstVC = subViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: false)
            let vc = firstVC as? WeatherViewController
            self.navigationItem.title = vc?.weatherKitViewModel.name
        }
    }
    
    // 어떻게 활용하지??
    private func bind(oldValue: Int, newValue: Int) {
//        guard let currentPage else { return }
//        let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
//        pageViewController.setViewControllers([subViewControllers[currentPage]], direction: direction, animated: false, completion: nil)
    }
}

// MARK: - PageViewController Delegate
extension MainPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
        
        if completed {
            DispatchQueue.main.async { [weak self] in
                let weatherVC = currentVC as! WeatherViewController
                self?.navigationItem.title = weatherVC.weatherKitViewModel.name
                weatherVC.mainView.todayWeatherView.layoutIfNeeded()
                weatherVC.mainView.yesterdayWeatherView.layoutIfNeeded()
                weatherVC.mainView.tomorrowdayWeatherView.layoutIfNeeded()
            }
        }
    }
}


// MARK: - CoreLocationManager Delegate
extension MainPageViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DEBUG: DidUpdateLocation")
        
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
        if let location = locations.last,
           let coordinate = locations.last?.coordinate {
            // ⭐️ 사용자 위치 정보 사용
            print("DEBUG: 위도 \(coordinate.latitude)")
            print("DEBUG: 경도 \(coordinate.longitude)")
            
            let latitudeDouble = Double(coordinate.latitude.formatted())
            let longitudeDouble = Double(coordinate.longitude.formatted())
            self.currentLatitude = latitudeDouble
            self.currentLongitude = longitudeDouble
            guard let latitudeDouble, let longitudeDouble else { return }
            let convertedGrid = ConvertGPS.convertGRIDtoGPS(mode: TO_GRID, lat_X: latitudeDouble, lng_Y: longitudeDouble)
            print("DEBUG: convertedGrid \(convertedGrid.x), \(convertedGrid.y)")
            self.convertedGridX = convertedGrid.x
            self.convertedGridY = convertedGrid.y
            
            self.geocoder.reverseGeocodeLocation(location, preferredLocale: self.locale) { [weak self] placemarks, _ in
                guard let placemarks,
                      let address = placemarks.last else { return }

                    self?.currentAdministrativeName = address.administrativeArea
                    self?.currentCityName = address.locality
                    self?.setupLayout()
                self?.setupViewControllersForBookmarked(city: address.locality, area: address.administrativeArea)
                    self?.setPageControlForCurrentLocation()
            }
            
        } else {
            self.setupLayout()
            self.setupViewControllersForBookmarked(city: nil, area: nil)
            self.setPageControlForCurrentLocation()
        }
        
        // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
        // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
        manager.stopUpdatingLocation()
        // 가져온 Location으로 현재위치 날씨를 VC에 추가
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkLocationServiceAuthorizationByVersion(manager)
        self.setupLayout()
        self.setupViewControllersForBookmarked(city: nil, area: nil)
        
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        self.setupLayout()
        self.setupViewControllersForBookmarked(city: nil, area: nil)
    }
}

// MARK: - Location Button Delegate
extension MainPageViewController: UpdatingLocationButtonDelegate {
    func updatingLocationButtonTapped() {
        print("DEBUG: check for location button!")
        self.setupViewControllersForBookmarked(city: nil, area: nil)
    }
}

//// MARK: - UserViewModel
//extension MainPageViewController: UserObserver {
//    func userUpdate<T>(updateValue: T) {
//        guard let value = updateValue as? UserModel else { return }
//        Dispatchqueue.main.async { [weak self] in
//            self.bulletionBoardViewController.userModel = value
//        }
//    }
//}

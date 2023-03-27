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
        pageControl.pageIndicatorTintColor = ColorForDarkMode.getSystemGray5Color()
        pageControl.currentPageIndicatorTintColor = ColorForDarkMode.getSystemGrayColor()
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
        self.setupViewControllersForBookmarked()
        self.setupViewControllersForBookmarked()
    }
    
    
    // MARK: - Helpers

    private func setupLayout(){
        self.addChild(pageViewController)
        view.addSubview(pageViewController.view)
        self.view.addSubview(pageControl)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    private func setupNav() {

        navigationController?.navigationBar.tintColor = ColorForDarkMode.getNavigationItemColor()
        navigationItem.rightBarButtonItem = listButton
        navigationItem.leftBarButtonItem = settingButton
        let backBarButtonItem = UIBarButtonItem(title: "",
                                                style: .plain,
                                                target: self,
                                                action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray5
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: AppFontName.bold, size: 20)!]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
    }
    
    private func checkLocationServiceAuthorizationByVersion(_ locationManager: CLLocationManager) {
            
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else {
                switchUserCurrentLocationAuthorization(locationManager.authorizationStatus)
                self.convertedGridX = nil
                self.convertedGridY = nil
                self.currentLatitude = nil
                self.currentLongitude = nil
            }
        } else {
            guard CLLocationManager.locationServicesEnabled() else {
                switchUserCurrentLocationAuthorization(CLLocationManager.authorizationStatus())
                return
            }
        }
    }
    
    private func switchUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showAlert("위치 정보 이용", "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", goSetting)
            self.setupLayout()
            self.setupViewControllersForBookmarked()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    func goSetting() {
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSetting)
        }
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

    private func setupViewControllersForBookmarked(){

        subViewControllers.removeAll()
        
        if let currentLatitude,
                  let currentLongitude,
                  let currentAdministrativeName,
                  let currentCityName,
                  let gridX = convertedGridX,
                  let gridY = convertedGridY {
            let vc = WeatherViewController()
            self.addActionBulletinBoardViewOpen(vc)
            if currentAdministrativeName != currentCityName {
                vc.weatherKitViewModel = .init(name: "\(currentAdministrativeName) \(currentCityName)",
                                               latitude: currentLatitude,
                                               longitude: currentLongitude,
                                               gridX: gridX,
                                               gridY: gridY)
            } else {
                vc.weatherKitViewModel = .init(name: "\(currentAdministrativeName)",
                                               latitude: currentLatitude,
                                               longitude: currentLongitude,
                                               gridX: gridX,
                                               gridY: gridY)
            }

            vc.mainView.todayWeatherView.buttonDelegate = self
            self.navigationItem.title = vc.weatherKitViewModel.name
            subViewControllers.append(vc)
            self.pageControl.numberOfPages = subViewControllers.count
            setupFisrtViewController()
        }
        
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
    
    private func bind(oldValue: Int, newValue: Int) {

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
        
        if let location = locations.last,
           let coordinate = locations.last?.coordinate {
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
                self?.setupViewControllersForBookmarked()
                    self?.setPageControlForCurrentLocation()
            }
        } else {
            self.setupLayout()
            self.setupViewControllersForBookmarked()
            self.setPageControlForCurrentLocation()
        }
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationServiceAuthorizationByVersion(manager)
        self.setupLayout()
        self.setupViewControllersForBookmarked()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.setupLayout()
        self.setupViewControllersForBookmarked()
    }
}

// MARK: - Location Button Delegate
extension MainPageViewController: UpdatingLocationButtonDelegate {
    func updatingLocationButtonTapped() {
        print("DEBUG: check for location button")
        self.setupViewControllersForBookmarked()
    }
}


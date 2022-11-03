//
//  MainViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//



import UIKit
import CoreLocation

class MainViewController: UIViewController {

// MARK: - properties
    

    
    var weatherArray: [WeatherItem] = []
    
    var weather: WeatherModel = WeatherModel() {
        didSet {
            DispatchQueue.main.async {
                
                
                //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
                self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)
                
            }
        }
    }

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
    
    lazy var activeVCs = [firstVC, secondVC]
    
    var chosenId = 0
    
    
    
    // MARK: - Properties for data fetching
    
    var todayDate: String = DateCalculate.todayDateString
    var yesterdayDate: String = DateCalculate.yesterdayDateString
    var tomorrowDate: String = DateCalculate.tomorrowDateString
    var nowtime: String = TimeCalculate.nowTimeString
    
    var nxForLoaction: String = "0"
    
    var nyForLocation: String = "0"
    
    
    // 위치정보 변수
    var locationManager = CLLocationManager()
    
//    var connectedGPS: Bool = false
    
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageVC()
//        uiPageControl 코드 작동 안함.
//        setupPageControll()
        setupNav()
        print("DEBUG: \(todayDate)")
        print("DEBUG: \(nowtime)")
        fetchWeatherData(date: self.todayDate, time: "0200", nx: "55", ny: "127") { weatherItems in
            self.sortWeatherCategory(weatherItems: weatherItems)
            print("DEBUG: weather Model fetched3 \(self.weather)")
            DispatchQueue.main.async {
//                self.updateWeather()

            }

        }
        checkUserDeviceLocationServiceAuthorization()
//        print("DEBUG: connectedGPS \(connectedGPS)")
        
    }

    

    
    
    // MARK: - Helpers
    
    func fetchWeatherData(date: String, time: String, nx: String, ny: String, completion: @escaping ([WeatherItem]) -> Void) {
        WeatherDataManager.shared.fetchWeather(date: date, time: time, nx: nx, ny: ny) { result in
            switch result {
            case .success(let weathers):
                self.weatherArray = weathers
                print(self.weatherArray)
                
                // 컴플리션 전달
                completion(self.weatherArray)
                print(self.weatherArray)
                DispatchQueue.main.async {

                    //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
                    self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sortWeatherCategory(weatherItems: [WeatherItem]) -> Void {
        weatherItems.forEach { item in
            
            if item.fcstDate == self.todayDate && item.fcstTime == self.nowtime {
                switch item.category {
                case WeatherItemCategory.humidityStatus.rawValue :
                    return self.weather.humidityStatus = item.fcstValue
                case WeatherItemCategory.temperaturePerHour.rawValue :
                    return self.weather.temperaturePerHour = item.fcstValue
                case WeatherItemCategory.skyStatus.rawValue :
                    return self.weather.skyStatus = item.fcstValue
                case WeatherItemCategory.rainingStatus.rawValue :
                    return self.weather.rainingStatus = item.fcstValue
                case WeatherItemCategory.windSpeed.rawValue :
                    return self.weather.windSpeed = item.fcstValue
                default :
                    break
                }
            }
            
            if item.fcstDate == self.todayDate && item.fcstTime == "1500" {
                switch item.category {
                case WeatherItemCategory.temperatureMax.rawValue :
                    return self.weather.temperatureMax = item.fcstValue
                default :
                    break
                }
                
            } else if item.fcstDate == self.todayDate && item.fcstTime == "0600" {
                switch item.category {
                case WeatherItemCategory.temperatureMin.rawValue :
                    return self.weather.temperatureMin = item.fcstValue
                default :
                    break
                }
            }
            
        }
        DispatchQueue.main.async {

            //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
            self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)
            
        }

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


extension MainViewController: UIPageViewControllerDataSource {
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


extension MainViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?[0] as? FirstViewController {
                
            }
        }
    }
}


extension MainViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DidUpdateLocation")
        
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
        if let coordinate = locations.last?.coordinate {
            // ⭐️ 사용자 위치 정보 사용
            print("DEBUG: 위도 \(coordinate.latitude)")
            print("DEBUG: 경도 \(coordinate.latitude)")
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            let convertedGrid = ConvertGPS.convertGRIDtoGPS(mode: TO_GRID, lat_X: lat, lng_Y: lon)
            self.nxForLoaction = String(convertedGrid.x)
            self.nyForLocation = String(convertedGrid.y)
            print("DEBUG: convertedGrid \(convertedGrid.x), \(convertedGrid.y)")
        }
        
        // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
        // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
        locationManager.stopUpdatingLocation()
//        locationManager.delegate?.locationManager?(locationManager, didChangeAuthorization: )
        
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

// 프로토콜로 전달 버전
/*
extension MainViewController: WeatherViewModel {
    func updateWeather() {
        DispatchQueue.main.async {
            self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)
            
        }
        
        
    }
    
    
}
*/

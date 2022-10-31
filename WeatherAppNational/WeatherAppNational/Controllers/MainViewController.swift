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
        setupLocationDelegate()
        
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
    
    func setupLocationDelegate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() == true {
            print("DEBUG: 위치서비스 on")
            locationManager.startUpdatingLocation()
//            print("DEBUG: 위치 : \(locationManager.location?.coordinate)")
        } else {
            print("DEBUG: 위치서비스 off")
        }

        
    }
    
    
    
    func locationServicesEnabled() async -> Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    func converXYtoGrid() {
   
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
        if let location = locations.first {
            print("DEBUG: 위도 : \(location.coordinate.latitude)")
            print("DEBUG: 경도 : \(location.coordinate.longitude)")
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
        
            let convertedGrid = ConvertGPS.convertGRIDtoGPS(mode: TO_GRID, lat_X: lat, lng_Y: lon)
            self.nxForLoaction = String(convertedGrid.x)
            self.nyForLocation = String(convertedGrid.y)
            print("DEBUG: convertedGrid \(convertedGrid.x), \(convertedGrid.y)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedWhenInUse {
 
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
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

# 어제보다

WeatherKit을 이용한 날씨 비교앱 
[https://apps.apple.com/kr/app/어제보다/id1664691738](https://apps.apple.com/kr/app/%EC%96%B4%EC%A0%9C%EB%B3%B4%EB%8B%A4/id1664691738)

- 프로젝트 소개
    - 어제의 날씨를 통해 오늘과 내일의 날씨를 유추할 수 있도록 만든 어플리케이션입니다.
    - 날씨앱 해커톤에 참여하며, 
    어제의 날씨와 비교하면 보다 직관적으로 오늘의 날씨를 확인하는데 도움이 될 수 있다는 아이디어로 어플리케이션을 기획하게 되었습니다.
    - 각 도시마다 게시판을 만들어 사람들이 직접 날씨 정보를 나누고 의견을 나눌 수 있도록 제작하고 있습니다. (version 2.0 업데이트 예정)
- 기술 스택
    - 언어: Swift5
    - 구조: MVVM
    - API: Apple WeatherKit, (기상청 API), Alamofire
    - UI: UIKit, SnapKit
    - 데이터베이스: CoreData, Firebase
    - 그 외: IQKeyboardManagerSwift
- 구현 기능
    - 날씨 예보
        - WeatherKit을 이용한 날씨 데이터로 어제/오늘/내일의 날씨를 즉각적으로 비교합니다.
        - CAGradientLayer를 통해 온도에 따라 view의 색상을 변경해 시각적으로 즐거움을 줍니다.
    - 도시 검색 및 관리
        - UIPageViewController와 UITableViewController를 연동해 여러 도시를 북마크하고 관리합니다.
        - CoreData를 이용해 도시 데이터를 저장하고 검색합니다.
    - 설계
        - MVVM 패턴을 사용해 데이터간의 의존성을 낮추고 기능의 활용성을 증대하였습니다.
        - Storyboard 없이 UIKit과 SnapKit으로 화면을 구성하였습니다.
- 구현 예정 기능
    - AppleLogin을 통해 정보를 받아 Firebase 서버에 계정 정보를 저장합니다.
    - 각 도시마다 Firebase 서버와 연동된 게시판을 생성해 당일 날씨에 관한 이야기를 나눌 수 있습니다.
- 참고
    - Luna의 날씨앱 해커톤 [https://cyber-patient-404.notion.site/1-iOS-with-at-the-791e36f87556461ebe570224d390d8e1](https://www.notion.so/791e36f87556461ebe570224d390d8e1)
    
- 주요 문제해결 과정
    - CLLocationManager 사용 경고 (연관이슈 [#2], [#7])
        - 문제 발생 :
            - Xcode 버전에 따른 CoreLocation 사용 방식의 차이로 인해 경고 발생.
            - CoreLocation은 location의 허용을 받는 delegate와 메서드가 일원화되어있지 않다. 특히 Xcode14부터 iOS 버전에 따라 필요 구현을 모두 구분해놓을 필요가 있다.
            - 실행엔 지장이 없었지만, 보다 clean한 코드를 위해 수정
        - 해결 :
            - 현재 locationService가 enabled인지 확인하는 코드를 버전별로 작성해 우선 처리.
            이후 다른 케이스를 위한 필요한 분기처리를 실행한다.
            - 코드
                
                ```swift
                func checkLocationServiceAuthorizationByVersion(_ locationManager: CLLocationManager) {
                            
                        if #available(iOS 14.0, *) {
                            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                                // 여기서 위치권한이 있을때 실행할 코드 입력
                                locationManager.startUpdatingLocation()
                            } else {
                                // 여기서 위치권환 off일때 실행할 코드 입력
                                switchUserCurrentLocationAuthorization(locationManager.authorizationStatus)
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
                    
                    func switchUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
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
                ```
                
    - MVVM 리팩토링 (연관이슈 [#4])
        - 문제 발생:
            - 기존 MVC 패턴으로 관리하던 구조에서 View 및 관리하는 데이터가 늘어나며 ViewController가 너무 비대해지는 문제 발생
            - 우선 ViewController를 관리하는 것 자체가 어려워지고, 차후 기능 추가 시에 더욱 부담스러워질 문제를 예비해 MVVM 패턴을 공부해 리팩토링 실행.
        - 해결:
            - Observer-Subscriber 프로토콜을 사용해, VC와 VM이 서로의 객체 생성 없이 Model 데이터를 주고받는다.
            - 장점: 델리게이트 패턴과 비슷한 프로토콜 방식으로 model을 VM에서 notify하면 VC는 update하기에 의존성이 없음.
            - 단점:
                - MVVM을 갖추기 위한 러닝커브가 있다.
                - 차후 VM끼리 데이터를 주고받을 때 시점 고려 필요
            - 코드:
                - Observer / Subscriber 코드
                    
                    ```swift
                    // Observer (VC)
                    protocol Observer {
                        func update<T>(updatedValue: T)
                    }
                    // Subscriber (VM)
                    protocol Subscriber {
                        var observer: (any Observer)? { get set }
                        mutating func unSubscribe(observer: (any Observer)?)
                        mutating func subscribe(observer: (any Observer)?)
                        func notify<T>(updatedValue: T)
                    }
                    ```
                    
                - View
                    - View에는 View를 구성하는 UI와, 외부(VC)에서 던져주는 Model 객체만 존재
                    
                    ```swift
                    
                    // View는 VC에서 Model을 받아 View를 configure한다.
                        // model을 받을때마다 데이터가 변동되야 하니까 didset.
                        var weatherModel: WeatherModel? {
                            didSet {
                                if let weatherModel = weatherModel {
                                    self.configureUI(weatherModel)
                                }
                            }
                        }
                    ```
                    
                - ViewModel
                    - Subscriber 프로토콜 채택. 프로토콜의 메서드들에 기본값 제공.
                    
                    ```swift
                    // 서브스크라이버 프로토콜 초기화. 기본값 넣어주기.
                    
                    extension WeatherViewModel: Subscriber {
                        func unSubscribe(observer: (Observer)?) {
                            self.observer = nil
                        }
                        
                        func subscribe(observer: (any Observer)?) {
                            self.observer = observer
                        }
                        
                        func notify<T>(updatedValue: T) {
                            observer?.update(updatedValue: updatedValue)
                        }
                    }
                    ```
                    
                    - VC와 연결할 observer 객체 생성.
                    
                    ```swift
                    // VC를 받을 옵저버 객체 만들어놓기 (일종의 델리게이트 프로퍼티)
                    internal var observer: (any Observer)?
                    ```
                    
                    - ModelDataManager로부터 Model을 받아와 model객체를 초기화.
                    - 이렇게 초기화한 model 값을 subscriber 프로토콜의 notify를 통해 전달
                    
                    ```swift
                    private var todayWeatherModel: WeatherModel = WeatherModel() {
                            didSet {
                                notify(updatedValue: [Day.today: todayWeatherModel])
                            }
                        }
                    ```
                    
                    ```swift
                    // 오늘 날씨
                            DispatchQueue.global().async { [weak self] in
                                guard let selfRef = self else { return }
                                WeatherService.shared.fetchWeatherData(dayType: Day.today,
                                                                       date: DateCalculate.yesterdayDateString,
                                                                       time: "2300",
                                                                       nx: selfRef.nx,
                                                                       ny: selfRef.ny) { result in
                                    switch result {
                                    case .success(let weatherModel):
                                        selfRef.todayWeatherModel = weatherModel
                                        
                                    case .failure(let error):
                                        print("오늘 날씨 불러오기 실패", error.localizedDescription)
                                    }
                                }
                            }
                    ```
                    
                - ViewController
                    - VM에서 받아온 Model을 View에 던져주는 역할
                    - 옵저버 프로토콜을 채택하고, update 함수에 전달하기 원하는 데이터 타입 구성.
                    - (각) View에 데이터를 전달한다.
                        - 유념 : update 함수는 subscriber 프로토콜에 notify 메서드로 연결되어 있다.이후 직접 호출되지 않음. (update 메서드에 입력받는 파라미터도 notify 메서드의 파라미터와 연결되어있음)
                        
                        ```swift
                        extension WeatherViewController: Observer {
                            func update<T>(updatedValue: T) {
                                guard let value = updatedValue as? [Day: WeatherModel] else { return }
                                DispatchQueue.main.async { [weak self] in
                                    switch value.first?.key {
                                    case .today:
                                        self?.mainView.todayWeatherView.weatherModel = value[.today]
                                    case .tomorrow:
                                        self?.mainView.tomorrowdayWeatherView.weatherModel = value[.tomorrow]
                                    case .yesterday:
                                        self?.mainView.yesterdayWeatherView.weatherModel = value[.yesterday]
                                    case .none:
                                        break
                                    }
                                } 
                            }
                        }
                        ```
                        
                    - VM에게 자신이(해당 VC가) 옵저버임을 알려야 함
                        - VM 프로퍼티 감시자로 만들어 subscribe할 옵저버 대상을 자신으로 놓기.
                        
                        ```swift
                        var viewModel: WeatherViewModel! {
                                didSet {
                                    viewModel.subscribe(observer: self)
                                }
                            }
                        ```
                        
                    - 이렇게 한 subscribe는 차후 해제해야 함
                        
                        ```swift
                        deinit {
                                viewModel.unSubscribe(observer: self)
                            }
                        ```
                        
    - MVVM 패턴에서 ViewModel간 데이터 전송(연관이슈 [#6], [#7])
        - 문제 발생:
            - 날씨 정보 모델을 다루는 VM에서 데이터를 받아 CAGradientLayer를 만드는 VM 구현 목적
            - VIewModel 간에 데이터를 다루는 시점에 대한 이해 필요
        - 해결:
            - VC에서 날씨 모델을 update할 때 업데이트되는 값을 이용해 CAGradientLayer VM을 초기화
            - 이후 같은 VC에서 CAGradienttLayer VM을 update
            
            ```swift
            extension WeatherViewController: WeatherKitObserver {
                func weatherKitUpdate<T>(updateValue: T) {
                    guard let value = updateValue as? [Day:WeatherKitModel] else { return }
                    DispatchQueue.main.async {
                        switch value.first?.key {
                        case .today:
                            self.mainView.todayWeatherView.weatherKitModel = value[.today]
                            self.colorsViewModel = .init(weatherKitModel: [.today: value[.today]] )
                        case .yesterday:
                            self.mainView.todayWeatherView.yesterdayDegree = value[.yesterday]?.temperature
                            self.mainView.yesterdayWeatherView.weatherKitModel = value[.yesterday]
                            self.colorsViewModel = .init(weatherKitModel: [.yesterday: value[.yesterday]])
                        case .tomorrow:
                            self.mainView.tomorrowdayWeatherView.weatherKitModel = value[.tomorrow]
                            self.colorsViewModel = .init(weatherKitModel: [.tomorrow: value[.tomorrow]])
                        case .none:
                            break
                        }
                    }
                }
            }
            
            extension WeatherViewController: ColorsObserver {
                func colorsUpdate<T>(updateValue: T) {
                    guard let value = updateValue as? [Day: CAGradientLayer] else { return }
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        switch value.first?.key {
                        case .today :
                            self.mainView.todayWeatherView.backgroundGradientLayer = value[.today]
                            // 여기서 불레틴뷰컨한테 값을 넘겨줘야하는데.... 뷰컨객체를 생성해야 한다고...? 그건아닌거같은데...
                            
                        case .yesterday:
                            self.mainView.yesterdayWeatherView.backgroundGradientLayer = value[.yesterday]
                        case .tomorrow:
                            self.mainView.tomorrowdayWeatherView.backgroundGradientLayer = value[.tomorrow]
                        case .none:
                            break
                        }
                    }
                }
            }
            ```
            
    - CALayer 업데이트 사이클을 이해한 CAGradientLayer 적용(연관이슈 [#7], [#8])
        - 문제 발생:
            - CAGradientLayer VM에서 데이터를 받아와도 layer에 적용되지 않음
            - view의 frame을 읽어오는 lifecycle과 layer 업데이트 시점, 그리고 여타 UI 요소들과 다른 CALayer 속성 이해 필요.
            - LayoutSubviews()를 직접 호출 시 실행 가능하지만, 데이터 과부화로 앱이 멈추는 현상 발생
        - 해결:
            - View의 layoutIfNeeded() 메서드에 VM에서 받아온 데이터로 UI 업데이트 내용 작성
            - View의 CAGradientLayer 모델에 속성감시자로 layoutIfNeeded() 실행
            - 코드
            
            ```swift
            var backgroundGradientLayer: CAGradientLayer? {
                    didSet {
                        self.layoutIfNeeded()
                    }
                }
            
            override func layoutIfNeeded() {
                    super.layoutIfNeeded()
                    self.setupBackgroundLayer()
                }
            
            func setupBackgroundLayer() {
                    DispatchQueue.main.async {
                        if let backgroundGradientLayer = self.backgroundGradientLayer {
                            if self.bounds != CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0) {
                                print("DEBUG: frame:\(self.frame)")
                                print("DEBUG: bounds:\(self.bounds)")
                                backgroundGradientLayer.frame = self.bounds
                                print("DEBUG: backgroundGrdientFrame:\(backgroundGradientLayer.frame)")
                                self.layer.addSublayer(backgroundGradientLayer)
                                self.setupUI()
                                self.layer.borderWidth = 0
                            }
                        }
                    }
                }
            ```

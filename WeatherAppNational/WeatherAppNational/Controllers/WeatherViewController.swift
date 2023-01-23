//
//  WeatherViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/12.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    lazy var mainView = MainView()
    
//    var weatherViewModel: WeatherViewModel! {
//        didSet {
//            weatherViewModel.subscribe(observer: self)
//        }
//    }
    
    var colorsViewModel: ColorsViewModel! {
        didSet {
            colorsViewModel.colorsSubscribe(observer: self)
        }
    }
    
    var weatherKitViewModel: WeatherKitViewModel! {
        didSet {
            weatherKitViewModel.subscribe(observer: self)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // 초기화 해제가 안됨 ( nil을 반환한다며 런타임 오류 뜸)
//    deinit {
////        weatherViewModel.unSubscribe(observer: self)
//        weatherKitViewModel.unsubscribe(observer: self)
//        colorsViewModel.colorsUnsubscribe(observer: self)
//    }

    // MARK: - Helpers
    func setupUI() {
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
/*
extension WeatherViewController: Observer {
    func update<T>(updateValue: T) {
        guard let value = updateValue as? [Day: WeatherModel] else { return }
        DispatchQueue.main.async { [weak self] in
            switch value.first?.key {
            case .today:
                self?.mainView.todayWeatherView.weatherModel = value[.today]
                self?.colorsViewModel = .init(weatherModel: [.today: value[.today]])
            case .yesterday:
                self?.mainView.yesterdayWeatherView.weatherModel = value[.yesterday]
                self?.mainView.todayWeatherView.yesterdayDegree = value[.yesterday]?.temperaturePerHour
                self?.colorsViewModel = .init(weatherModel:[.yesterday: value[.yesterday]] )
            case .tomorrow:
                self?.mainView.tomorrowdayWeatherView.weatherModel = value[.tomorrow]
                self?.colorsViewModel = .init(weatherModel: [.tomorrow: value[.tomorrow]])
            case .none:
                break
            }
        }
    }
}
*/

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

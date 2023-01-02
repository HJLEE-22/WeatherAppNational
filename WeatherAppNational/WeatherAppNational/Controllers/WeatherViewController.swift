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
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            weatherViewModel.subscribe(observer: self)
        }
    }
    
    var colorsViewModel: ColorsViewModel! {
        didSet {
            colorsViewModel.subscribe(observer: self)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    deinit {
        weatherViewModel.unSubscribe(observer: self)
        colorsViewModel.unSubscribe(observer: self)
    }

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

extension WeatherViewController: Observer {
    func update<T>(updateValue: T) {
        guard let value = updateValue as? [Day: WeatherModel] else { return }
        DispatchQueue.main.async { [weak self] in
            switch value.first?.key {
            case .today:
                self?.mainView.todayWeatherView.weatherModel = value[.today]
                self?.colorsViewModel = .init(weatherModel: value[.today])
            case .yesterday:
                self?.mainView.yesterdayWeatherView.weatherModel = value[.yesterday]
                self?.mainView.todayWeatherView.yesterdayDegree = value[.yesterday]?.temperaturePerHour
                self?.colorsViewModel = .init(weatherModel: value[.yesterday])
            case .tomorrow:
                self?.mainView.tomorrowdayWeatherView.weatherModel = value[.tomorrow]
                self?.colorsViewModel = .init(weatherModel: value[.tomorrow])
            case .none:
                break
            }
        }
    }
}

extension WeatherViewController: ColorsObserver {
    func colorsUpdate<T>(updateValue: T) {
        print("DEBUG: checking for colorsObserver:\(updateValue)")
// 문제: colorsViewModel을 subscribe할 때 observer를 self로 등록했음에도 계속 nil...
        // 아닌데? nil 아니고 제대로 self(VC) 받는데?
        // -> 저기선 nil이 아닌데, ColorsVM에서 nil이 된다!
        guard let value = updateValue as? CAGradientLayer else { return }
        
    }
}

/*
extension WeatherViewController: ColorsObserver {
    func colorsUpdate<T>(updateValue: T) {
        guard let value = updateValue as? [Day: CAGradientLayer] else { return }
            switch value.first?.key {
            case .today:
                self.mainView.todayWeatherView.backgroundGraidentLayer = value[.today]
                print("DEBUG: backgroundGraidentLayer:\(self.mainView.todayWeatherView.backgroundGraidentLayer)")
            case .yesterday:
                self.mainView.yesterdayWeatherView.backgroundGraidentLayer = value[.yesterday]
            case .tomorrow:
                self.mainView.tomorrowdayWeatherView.backgroundGraidentLayer = value[.tomorrow]
            case .none:
                break
        }
    }
}
*/



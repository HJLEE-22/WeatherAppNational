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
            colorsViewModel.colorsSubscribe(observer: self)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        weatherViewModel.unSubscribe(observer: self)
        colorsViewModel.colorsUnSubscribe(observer: self)
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

extension WeatherViewController: ColorsObserver {
    func colorsUpdate<T>(updateValue: T) {
        guard let value = updateValue as? [Day: CAGradientLayer] else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch value.first?.key {
            case .today :
                self.mainView.todayWeatherView.backgroundGradientLayer = value[.today]
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





//
//  WeatherViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/12.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    lazy var mainView = MainView()
    
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
    
    deinit {
        weatherKitViewModel.unsubscribe(observer: self)
        colorsViewModel.colorsUnsubscribe(observer: self)
    }

    // MARK: - Helpers
    private func setupUI() {
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

extension WeatherViewController: WeatherKitObserver {
    func weatherKitUpdate<T>(updateValue: T) {
        guard let value = updateValue as? [Day:WeatherKitModel] else { return }
        DispatchQueue.main.async { [weak self] in
            switch value.first?.key {
            case .today:
                self?.mainView.todayWeatherView.weatherKitModel = value[.today]
                self?.colorsViewModel = .init(weatherKitModel: [.today: value[.today]] )
            case .yesterday:
                self?.mainView.todayWeatherView.yesterdayDegree = value[.yesterday]?.temperature
                self?.mainView.yesterdayWeatherView.weatherKitModel = value[.yesterday]
                self?.colorsViewModel = .init(weatherKitModel: [.yesterday: value[.yesterday]])
            case .tomorrow:
                self?.mainView.tomorrowdayWeatherView.weatherKitModel = value[.tomorrow]
                self?.colorsViewModel = .init(weatherKitModel: [.tomorrow: value[.tomorrow]])
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
            //guard let self else { return }
            switch value.first?.key {
            case .today :
                self?.mainView.todayWeatherView.backgroundGradientLayer = value[.today]
            case .yesterday:
                self?.mainView.yesterdayWeatherView.backgroundGradientLayer = value[.yesterday]
            case .tomorrow:
                self?.mainView.tomorrowdayWeatherView.backgroundGradientLayer = value[.tomorrow]
            case .none:
                break
            }
        }
    }
}

//
//  WeatherViewController.swift
//  WeatherAppNational
//
//  Created by Mingu Seo on 2022/11/05.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private lazy var mainView = MainView()
    var viewModel: WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupUI()
        
        viewModel.subscribe(observer: self)
    }
    
    func setupUI() {
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
}

extension WeatherViewController: Observer {
    func update<T>(updatedValue: T) {
        guard let value = updatedValue as? [Day: WeatherModel] else { return }
        switch value.first?.key {
        case .today:
            mainView.todayWeatherView.weatherModel = value[.today]
        case .tomorrow:
            mainView.tomorrowdayWeatherView.weatherModel = value[.tomorrow]
        case .yesterday:
            mainView.yesterdayWeatherView.weatherModel = value[.yesterday]
        case .none:
            break
        }
    }
}


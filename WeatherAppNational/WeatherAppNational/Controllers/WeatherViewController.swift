//
//  WeatherViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/12.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var mainView = MainView()

    var viewModel: WeatherViewModel! {
        didSet {
            viewModel.subscribe(observer: self)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        setupUI()
    }
    
    deinit {
        viewModel.unSubscribe(observer: self)
    }
    
    // MARK: - Helpers
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
    func update<T>(updateValue: T) {
        guard let value = updateValue as? [Day: WeatherModel] else { return }
        DispatchQueue.main.async { [weak self] in
            switch value.first?.key {
            case .today:
                self?.mainView.todayWeatherView.weatherModel = value[.today]
            case .yesterday:
                self?.mainView.yesterdayWeatherView.weatherModel = value[.yesterday]
            case .tomorrow:
                self?.mainView.tomorrowdayWeatherView.weatherModel = value[.tomorrow]
            case .none:
                break
            }
        }
        
    }
    
    
}


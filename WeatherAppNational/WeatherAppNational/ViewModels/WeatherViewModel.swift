//
//  WeatherViewModel.swift
//  WeatherAppNational
//
//  Created by Mingu Seo on 2022/11/05.
//

import UIKit
import CoreLocation

enum Day {
    case today
    case yesterday
    case tomorrow
}

class WeatherViewModel {
    internal var observer: (any Observer)?
    
    private var locationManager = CLLocationManager()
    private var todayDate: String = DateCalculate.todayDateString
    private var yesterdayDate: String = DateCalculate.yesterdayDateString
    private var tomorrowDate: String = DateCalculate.tomorrowDateString
    private var nowtime: String = TimeCalculate.nowTimeString
    private var name: String!
    private var nx: Int!
    private var ny: Int!
    
    private var todayWeatherModel: WeatherModel = WeatherModel() {
        didSet {
            notify(updatedValue: [Day.today: todayWeatherModel])
        }
    }
    
    private var yesterdayWeatherModel: WeatherModel = WeatherModel() {
        didSet {
            notify(updatedValue: [Day.yesterday: yesterdayWeatherModel])
        }
    }
    
    private var tomorrowWeatherModel: WeatherModel = WeatherModel() {
        didSet {
            notify(updatedValue: [Day.tomorrow: tomorrowWeatherModel])
        }
    }
    
    init(name: String, nx: Int, ny: Int) {
        self.name = name
        self.nx = nx
        self.ny = ny
        
        bind()
        
    }
    
    private func bind() {
        // 오늘 날씨
        DispatchQueue.global().async { [weak self] in
            guard let selfRef = self else { return }
            WeatherService.shared.fetchWeatherData(dayType: Day.today, date: DateCalculate.todayDateString,
                                                   time: "0200",
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
        
        // 어제 날씨
        DispatchQueue.main.async { [weak self] in
            guard let selfRef = self else { return }
            WeatherService.shared.fetchWeatherData(dayType: Day.yesterday, date: DateCalculate.yesterdayDateString,
                                                   time: "0200",
                                                   nx: selfRef.nx,
                                                   ny: selfRef.ny) { result in
                switch result {
                case .success(let weatherModel):
                    selfRef.yesterdayWeatherModel = weatherModel
                    
                case .failure(let error):
                    print("어제 날씨 불러오기 실패", error.localizedDescription)
                }
            }
        }
      
        // 내일 날씨
        DispatchQueue.main.async { [weak self] in
            guard let selfRef = self else { return }
            WeatherService.shared.fetchWeatherData(dayType: Day.tomorrow, date: DateCalculate.todayDateString,
                                                   time: "0200",
                                                   nx: selfRef.nx,
                                                   ny: selfRef.ny) { result in
                switch result {
                case .success(let weatherModel):
                    selfRef.tomorrowWeatherModel = weatherModel
                    
                case .failure(let error):
                    print("내일 날씨 불러오기 실패", error)
                }
            }
        }
    }
}

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


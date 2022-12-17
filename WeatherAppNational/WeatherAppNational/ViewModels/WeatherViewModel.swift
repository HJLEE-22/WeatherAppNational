//
//  WeatherViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/12.
//

import UIKit
import CoreLocation

enum Day {
    case today
    case yesterday
    case tomorrow
}

class WeatherViewModel {
    
    // MARK: - Properties
    var observer: (any Observer)?
    
    private var locationManager = CLLocationManager()
    private var todayDate = DateCalculate.todayDateString
    private var yesterdayDate = DateCalculate.yesterdayDateString
    private var tomorrowDate = DateCalculate.tomorrowDateString
    private var nowTime = TimeCalculate.nowTimeString
    var name: String!
    private var nx: Int!
    private var ny: Int!
    
    private var todayWeatherModel: WeatherModel = WeatherModel() {
        didSet{
            notify(updateValue: [Day.today: todayWeatherModel])
        }
    }
    
    private var yesterDayWeatherModel: WeatherModel = WeatherModel() {
        didSet{
            notify(updateValue: [Day.yesterday: yesterDayWeatherModel])
        }
    }
    
    private var tomorrowWeatherModel: WeatherModel = WeatherModel() {
        didSet{
            notify(updateValue: [Day.tomorrow: tomorrowWeatherModel])
        }
    }
    
    // MARK: - Lifecycle
    
    init(name: String, nx: Int, ny: Int) {
        self.name = name
        self.nx = nx
        self.ny = ny
        
        self.bind()
    }
    
    // MARK: - Helpers
    
    func bind() {
        
        // 오늘 날씨
        DispatchQueue.global().async { [weak self] in
            guard let selfRef = self else { return }
            WeatherService.shared.fetchWeatherData(dayType: .today,
                                                   date: DateCalculate.yesterdayDateString,
                                                   time: "2300",
                                                   nx: selfRef.nx, ny: selfRef.ny) { result in
                switch result {
                case .success(let weatherModel):
                    selfRef.todayWeatherModel = weatherModel
                    print("DEBUG: weatherModel : \(weatherModel)")
                case .failure(let error):
                    print("DEBUG: 오늘 날씨 불러오기 실패", error.localizedDescription)
                }
            }
        }
        
        // 어제 날씨
        DispatchQueue.global().async { [weak self] in
            guard let selfRef = self else { return }
            WeatherService.shared.fetchWeatherData(dayType: .yesterday,
                                                   date: DateCalculate.yesterdayDateString,
                                                   time: "0200",
                                                   nx: selfRef.nx, ny: selfRef.ny) { result in
                switch result {
                case .success(let weatherModel):
                    selfRef.yesterDayWeatherModel = weatherModel
                case .failure(let error):
                    print("DEBUG: 어제 날씨 불러오기 실패", error.localizedDescription)
                }
            }
        }
        // 내일 날씨
        DispatchQueue.global().async { [weak self] in
            guard let selfRef = self else { return }
            WeatherService.shared.fetchWeatherData(dayType: .tomorrow,
                                                   date: DateCalculate.yesterdayDateString,
                                                   time: "2300",
                                                   nx: selfRef.nx, ny: selfRef.ny) { result in
                switch result {
                case .success(let weatherModel):
                    selfRef.tomorrowWeatherModel = weatherModel
                case .failure(let error):
                    print("DEBUG: 내일 날씨 불러오기 실패", error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Subscriber 선언
extension WeatherViewModel: Subscriber {
    func subscribe(observer: (Observer)?) {
        self.observer = observer
    }
    
    func unSubscribe(observer: (Observer)?) {
        self.observer = nil
    }
    
    func notify<T>(updateValue: T) {
        observer?.update(updateValue: updateValue)
    }
}

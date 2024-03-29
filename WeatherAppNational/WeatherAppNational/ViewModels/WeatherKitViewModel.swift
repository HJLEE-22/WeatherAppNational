//
//  WeatherKitViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/07.
//

import Foundation
import WeatherKit
import CoreLocation

final class WeatherKitViewModel {
    
    var observer: WeatherKitObserver?
    
    // MARK: - Properties
    private let weatherService = WeatherService()
    var name: String?
    private var latitude: Double?
    private var longitude: Double?
    private var location: CLLocation?
    private var gridX: Int?
    private var gridY: Int?
    
    private var todayWeatherKitModel: WeatherKitModel = WeatherKitModel() {
        didSet{
            self.notify(updateValue: [Day.today:todayWeatherKitModel])
        }
    }
    
    private var yesterdayWeatherKitModel: WeatherKitModel = WeatherKitModel() {
        didSet{
            self.notify(updateValue: [Day.yesterday:yesterdayWeatherKitModel])
        }
    }
    
    private var tomorrowWeatherKitModel: WeatherKitModel = WeatherKitModel() {
        didSet{
            self.notify(updateValue: [Day.tomorrow:tomorrowWeatherKitModel])
        }
    }
    
    // MARK: - Life cycle
    init(name: String, latitude: Double, longitude: Double, gridX: Int, gridY: Int) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.gridX = gridX
        self.gridY = gridY
        self.bind(locaton: self.location)
    }
    
    // MARK: - Actions
    
    private func bind(locaton: CLLocation?) {
        guard let location else { return }
        Task{
            await self.getCurrentWeather(location: location)
            await self.getYesterdayWeather(location: location)
            await self.getTomorrowWeather(location: location)
        }
    }
    
    private func getCurrentWeather(location: CLLocation) async {
        do {
            let weather = try await weatherService.weather(for: location)
            let nowTemperature = String(Int(Double(weather.currentWeather.temperature.converted(to: .celsius).formatted().dropLast(2))?.rounded(.awayFromZero) ?? 100))
            print("DEBUG: nowTem:\(weather.currentWeather.temperature.converted(to: .celsius).formatted())")

            let humidity = String(weather.currentWeather.humidity)
            let windSpeed = weather.currentWeather.wind.speed.formatted()
            let symbolName = weather.currentWeather.symbolName
            
            var hignTemperature: String?
            var lowTemperature: String?

            let dailyWeather = try await weatherService.weather(for: location, including: .daily)
            dailyWeather.filter({ $0.date.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted)}).forEach { day in
                print("DEBUG: daily:\(day)")
                hignTemperature = String(Int(Double(day.highTemperature.formatted(.measurement(width: .narrow)).dropLast(2))?.rounded(.awayFromZero) ?? 100))
                lowTemperature = String(Int(Double(day.lowTemperature.formatted(.measurement(width: .narrow)).dropLast(2))?.rounded(.awayFromZero) ?? 100))
            }

            self.todayWeatherKitModel = WeatherKitModel(temperature: nowTemperature, highTemperature: hignTemperature, lowTemperature: lowTemperature, humidity: humidity, windSpeed: windSpeed, symbolName: symbolName)
            print("DEBUG: name: \(self.name), location: \(location), todayWeatherKitModel:\(self.todayWeatherKitModel)")

        } catch {
            // WeatherKit에서 어제 날씨 데이터 오류날 시 기상청 API 접속
            print(error.localizedDescription)
            guard let gridX, let gridY else { return }
            try await CustomWeatherService.shared.fetchWeatherData(dayType: .today,
                                                                   date: DateCalculate.todayDateString,
                                                                   time: "0200",
                                                                   nx: gridX,
                                                                   ny: gridY,
                                                                   count: 350 ) { result in
                switch result {
                case .success(let weatherKitModel):
                    self.todayWeatherKitModel = weatherKitModel
                case .failure(let error):
                    print("DEBUG: 어제 날씨 불러오기 실패", error.localizedDescription)
                }
            }

        }
    }
    
    private func getYesterdayWeather(location: CLLocation) async {
        guard let gridX, let gridY else { return }
        try await CustomWeatherService.shared.fetchWeatherData(dayType: .yesterday,
                                                               date: DateCalculate.yesterdayDateString,
                                                               time: "0200",
                                                               nx: gridX,
                                                               ny: gridY,
                                                               count: 350) { result in
            switch result {
            case .success(let weatherKitModel):
                self.yesterdayWeatherKitModel = weatherKitModel
            case .failure(let error):
                print("DEBUG: 어제 날씨 불러오기 실패", error.localizedDescription)
            }
        }
    }
    
    private func getTomorrowWeather(location: CLLocation) async {
        do {
            let tomorrow = Date() + 86400
            let tomorrowFormatted = tomorrow.formatted(.dateTime.year(.twoDigits)
                                                                .month(.narrow)
                                                                .day(.defaultDigits)
                                                                .hour(.twoDigits(amPM: .narrow)))
            var tomorrowTemperature: String?
            var tomorrowHignTemperature: String?
            var tomorrowLowTemperature: String?
            var tomorrowSymbolName: String?
            

            let hourWeather = try await weatherService.weather(for: location, including: .hourly)
            print("DEBUG: tmr hour weather weather:\(hourWeather)")

            let hourWeatherFiltered = hourWeather.filter({ $0.date.formatted(.dateTime.year(.twoDigits)
                                                            .month(.narrow)
                                                            .day(.defaultDigits)
                                                            .hour(.twoDigits(amPM: .narrow))) == tomorrowFormatted}).first

            tomorrowSymbolName = hourWeatherFiltered?.symbolName
            let tomorrowTemperatrueFormatted = String(Int(Double(hourWeatherFiltered?.temperature.formatted().dropLast(2) ?? "0")?.rounded(.awayFromZero) ?? 0))
            tomorrowTemperature = tomorrowTemperatrueFormatted


            let dailyWeather = try await weatherService.weather(for: location, including: .daily)

            dailyWeather.filter({ $0.date.formatted(date: .numeric, time: .omitted) == tomorrow.formatted(date: .numeric, time: .omitted)}).forEach { day in
                print("DEBUG: daily:\(day)")
                tomorrowHignTemperature = String(Int(Double(day.highTemperature.formatted(.measurement(width: .narrow)).dropLast(2))?.rounded(.awayFromZero) ?? 100))
                tomorrowLowTemperature = String(Int(Double(day.lowTemperature.formatted(.measurement(width: .narrow)).dropLast(2))?.rounded(.awayFromZero) ?? 100))
            }
            tomorrowWeatherKitModel = WeatherKitModel(temperature: tomorrowTemperature, highTemperature: tomorrowHignTemperature, lowTemperature: tomorrowLowTemperature, symbolName: tomorrowSymbolName)
        } catch {
            // WeatherKit에서 어제 날씨 데이터 오류날 시 기상청 API 접속
            print(error.localizedDescription)
            guard let gridX, let gridY else { return }
            try await CustomWeatherService.shared.fetchWeatherData(dayType: .tomorrow,
                                                                   date: DateCalculate.todayDateString,
                                                                   time: "0200",
                                                                   nx: gridX,
                                                                   ny: gridY,
                                                                   count: 750) { result in
                switch result {
                case .success(let weatherKitModel):
                    self.tomorrowWeatherKitModel = weatherKitModel
                case .failure(let error):
                    print("DEBUG: 어제 날씨 불러오기 실패", error.localizedDescription)
                }
            }
        }
    }
}

extension WeatherKitViewModel: WeatherKitSubcriber {
    
    func subscribe(observer: WeatherKitObserver?) {
        self.observer = observer
    }
    
    func unsubscribe(observer: WeatherKitObserver?) {
        self.observer = nil
    }
    
    func notify<T>(updateValue: T) {
        self.observer?.weatherKitUpdate(updateValue: updateValue)
    }
}

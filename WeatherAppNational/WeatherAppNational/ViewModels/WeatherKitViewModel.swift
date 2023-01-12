//
//  WeatherKitViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/07.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherKitViewModel {
    
    var observer: WeatherKitObserver?
    
    // MARK: - Properties
    let weatherService = WeatherService()
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var location: CLLocation?
    
    var todayWeatherKitModel: WeatherKitModel = WeatherKitModel() {
        didSet{
            self.notify(updateValue: [Day.today:todayWeatherKitModel])
        }
    }
    
    var yesterdayWeatherKitModel: WeatherKitModel = WeatherKitModel() {
        didSet{
            self.notify(updateValue: [Day.yesterday:yesterdayWeatherKitModel])
        }
    }
    
    var tomorrowWeatherKitModel: WeatherKitModel = WeatherKitModel() {
        didSet{
            self.notify(updateValue: [Day.tomorrow:tomorrowWeatherKitModel])
        }
    }
    
    // MARK: - Life cycle
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        
        self.bind(locaton: self.location)
    }
    
    // MARK: - Actions
    
    func bind(locaton: CLLocation?) {
        guard let location else { return }
        Task{
            await self.getCurrentWeather(location: location)
            await self.getYesterdayWeather(location: location)
            await self.getTomorrowWeather(location: location)
        }
    }
    
    func getCurrentWeather(location: CLLocation) async {
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
            print(error.localizedDescription)
        }
    }
    
    func getYesterdayWeather(location: CLLocation) async {
        do {
            let yesterday = Date() - 86400
            let yesterdayFormatted = yesterday.formatted(.dateTime.year(.twoDigits)
                                                                .month(.narrow)
                                                                .day(.defaultDigits)
                                                                .hour(.twoDigits(amPM: .narrow)))
            var yesterdayTemperature: String?
            var yesterdayHighTemperature: String?
            var yesterdayLowTemperature: String?
            var yesterdaySymbolName: String?
/*
            let hourWeather = try await weatherService.weather(for: location, including: .hourly(startDate: yesterday, endDate: yesterday))
            let hourWeatherCurrent = try await weatherService.weather(for: location, including: .hourly(startDate: Date(), endDate: Date()))
            print("DEBUG: hourWeather:\(hourWeather)")
            print("DEBUG: hourWeather current:\(hourWeatherCurrent)")


            let hourWeatherFiltered = hourWeather.filter({ $0.date.formatted(.dateTime.year(.twoDigits)
                                                            .month(.narrow)
                                                            .day(.defaultDigits)
                                                            .hour(.twoDigits(amPM: .narrow))) == yesterdayFormatted}).first
            print("DEBUG: hourWeatherFiltered:\(hourWeatherFiltered)")

            yesterdaySymbolName = hourWeatherFiltered?.symbolName
            let yesterdayTemperatrueFormatted = String(Int(Double(hourWeatherFiltered?.temperature.formatted().dropLast(2) ?? "0")?.rounded(.awayFromZero) ?? 0))
            yesterdayTemperature = yesterdayTemperatrueFormatted
            */
            let hourWeather = try await weatherService.weather(for: location, including: .hourly(startDate: yesterday, endDate: yesterday))

            hourWeather.forEach { hour in
                print("DEBUG: hourWeather:\(hour)")
                print("DEBUG: date:\(Date())")
                yesterdayTemperature = String(Int(Double(hour.temperature.formatted(.measurement(width: .narrow)).dropLast(2))?.rounded(.awayFromZero) ?? 100))
                yesterdaySymbolName = hour.symbolName
            }
            let dailyWeather = try await weatherService.weather(for: location, including: .daily(startDate: yesterday, endDate: yesterday))
            print("DEBUG: dailyWeather:\(dailyWeather)")

            yesterdayHighTemperature = String(Int((dailyWeather.first?.highTemperature.value ?? 100).rounded(.awayFromZero)))
            yesterdayLowTemperature = String(Int((dailyWeather.first?.lowTemperature.value ?? 100).rounded(.awayFromZero)))
            
            yesterdayWeatherKitModel = WeatherKitModel(temperature: yesterdayTemperature, highTemperature: yesterdayHighTemperature, lowTemperature: yesterdayLowTemperature, symbolName: yesterdaySymbolName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getTomorrowWeather(location: CLLocation) async {
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
            print(error.localizedDescription)
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

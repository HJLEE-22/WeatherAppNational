//
//  WeatherService.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/04.
//

import Foundation

final class CustomWeatherService {
    
    static let shared = CustomWeatherService()
    
    func fetchWeatherData(dayType:Day, date: String, time: String, nx: Int, ny: Int, count: Int, completion: @escaping (Result<WeatherKitModel, Error>) -> Void) {
        WeatherDataManager.shared.fetchWeather(date: date, time: time, nx: nx, ny: ny, count: count) {[weak self] result in
            switch result {
            case .success(let weathers):

                if let weatherKitModel = self?.sortWeatherCategory(dayType: dayType,
                                                                date: date,
                                                                time: time,
                                                                weatherItems: weathers) {
                    completion(.success(weatherKitModel))
                } else {
                    completion(.failure(NetworkError.dataError))
                }

            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func sortWeatherCategory(dayType: Day, date: String, time: String ,weatherItems: [WeatherItem]) -> WeatherKitModel {
        
        let currentTime = TimeCalculate.nowTimeString
        
        var weatherItemsTemp = weatherItems
        
        switch dayType {
        case .today:
            weatherItemsTemp = weatherItemsTemp.filter({ $0.fcstDate == DateCalculate.todayDateString})
        case .yesterday:
            weatherItemsTemp = weatherItemsTemp.filter({ $0.fcstDate == DateCalculate.yesterdayDateString})
        case .tomorrow:
            weatherItemsTemp = weatherItemsTemp.filter({ $0.fcstDate == DateCalculate.tomorrowDateString})
        }
        
        let currentTemperature = weatherItemsTemp.filter({$0.fcstTime == currentTime && $0.category == WeatherItemCategory.temperaturePerHour.rawValue}).first?.fcstValue
        let minTemperature = weatherItemsTemp.filter({$0.fcstTime == "0600" && $0.category == WeatherItemCategory.temperatureMin.rawValue}).first?.fcstValue
        let maxTemperature = weatherItemsTemp.filter({$0.fcstTime == "1500" && $0.category == WeatherItemCategory.temperatureMax.rawValue}).first?.fcstValue
        
        let skystatus = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.skyStatus.rawValue }.first?.fcstValue
        let rainingStatus = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.rainingStatus.rawValue }.first?.fcstValue
        let humidityStatus = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.humidityStatus.rawValue }.first?.fcstValue
        let windSpeed = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.windSpeed.rawValue }.first?.fcstValue
        
        return .init(temperature: currentTemperature, highTemperature: maxTemperature, lowTemperature: minTemperature, humidity: humidityStatus, windSpeed: windSpeed, rainingStatus: rainingStatus, skyStatus: skystatus)
    }
    
}

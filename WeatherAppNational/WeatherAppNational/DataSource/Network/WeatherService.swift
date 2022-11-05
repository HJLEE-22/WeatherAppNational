//
//  WeatherService.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/04.
//

import Foundation

class WeatherService {
    
    
    static let shared = WeatherService()
    
    func fetchWeatherData(dayType: Day, date: String, time: String, nx: Int, ny: Int, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        WeatherDataManager.shared.fetchWeather(date: date, time: time, nx: nx, ny: ny) { [weak self] result in
            switch result {
            case .success(let weathers):
                // 컴플리션 전달
                if let weatherModel = self?.sortWeatherCategory(dayType: dayType, date: date,
                                                                time: time,
                                                                weatherItems: weathers) {
                    completion(.success(weatherModel))
                } else {
                    completion(.failure(NetworkError.dataError))
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func sortWeatherCategory(dayType: Day, date: String, time: String, weatherItems: [WeatherItem]) -> WeatherModel {
        var weatherModel = WeatherModel()
        // 현재온도: 현재시간
        // 최저온도 : 06시
        // 최고온도: 15시
        // 습도, 바람, 날씨 : 현재시간
        
        let currentTime = TimeCalculate.nowTimeString
        
        let weatherItemsTemp = dayType == .tomorrow ? weatherItems.filter({ $0.fcstDate == DateCalculate.tomorrowDateString }) : weatherItems.filter({ $0.fcstDate == date })
        
        let currentTemperature = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.temperaturePerHour.rawValue }.first?.fcstValue
        let minTemperature = weatherItemsTemp.filter { $0.fcstTime == "0600" && $0.category == WeatherItemCategory.temperatureMin.rawValue }.first?.fcstValue
        let maxTemperature = weatherItemsTemp.filter { $0.fcstTime == "1500" && $0.category == WeatherItemCategory.temperatureMax.rawValue }.first?.fcstValue
        
        let skystatus = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.skyStatus.rawValue }.first?.fcstValue
        let rainingStatus = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.rainingStatus.rawValue }.first?.fcstValue
        let humidityStatus = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.humidityStatus.rawValue }.first?.fcstValue
        let windSpeed = weatherItemsTemp.filter { $0.fcstTime == currentTime && $0.category == WeatherItemCategory.windSpeed.rawValue }.first?.fcstValue
        
        return .init(humidityStatus: humidityStatus, temperatureMax: maxTemperature, temperatureMin: minTemperature, temperaturePerHour: currentTemperature, windSpeed: windSpeed, rainingStatus: rainingStatus, skyStatus: skystatus)
    }
    
}

//
//  WeatherService.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/04.
//

import Foundation

class WeatherService {
    
    static let shared = WeatherService()
    

    func fetchWeatherData(dayType:Day, date: String, time: String, nx: Int, ny: Int, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        WeatherDataManager.shared.fetchWeather(date: date, time: time, nx: nx, ny: ny) {[weak self] result in
            switch result {
            case .success(let weathers):

                if let weatherModel = self?.sortWeatherCategory(dayType: dayType,
                                                                date: date,
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
    
    func sortWeatherCategory(dayType: Day, date: String, time: String ,weatherItems: [WeatherItem]) -> WeatherModel {
        
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
        
        
        return .init(humidityStatus: humidityStatus, temperatureMax: maxTemperature, temperatureMin: minTemperature, temperaturePerHour: currentTemperature, windSpeed: windSpeed, rainingStatus: rainingStatus, skyStatus: skystatus)
        
        
        
        /*
         
         var weather: WeatherModel = WeatherModel() {
             didSet {
                 DispatchQueue.main.async {
     
     //
     //                //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
     //                self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)
     
                 }
             }
         }
         
        weatherItems.forEach { item in
            
            if item.fcstDate == self.todayDate && item.fcstTime == self.nowtime {
                switch item.category {
                case WeatherItemCategory.humidityStatus.rawValue :
                    return self.weather.humidityStatus = item.fcstValue
                case WeatherItemCategory.temperaturePerHour.rawValue :
                    return self.weather.temperaturePerHour = item.fcstValue
                case WeatherItemCategory.skyStatus.rawValue :
                    return self.weather.skyStatus = item.fcstValue
                case WeatherItemCategory.rainingStatus.rawValue :
                    return self.weather.rainingStatus = item.fcstValue
                case WeatherItemCategory.windSpeed.rawValue :
                    return self.weather.windSpeed = item.fcstValue
                default :
                    break
                }
            }
            
            if item.fcstDate == self.todayDate && item.fcstTime == "1500" {
                switch item.category {
                case WeatherItemCategory.temperatureMax.rawValue :
                    return self.weather.temperatureMax = item.fcstValue
                default :
                    break
                }
                
            } else if item.fcstDate == self.todayDate && item.fcstTime == "0600" {
                switch item.category {
                case WeatherItemCategory.temperatureMin.rawValue :
                    return self.weather.temperatureMin = item.fcstValue
                default :
                    break
                }
            }
            
        }
        DispatchQueue.main.async {

            //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
            
        }
*/
    }
    
}

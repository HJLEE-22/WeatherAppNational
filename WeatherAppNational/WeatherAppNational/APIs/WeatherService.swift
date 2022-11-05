//
//  WeatherService.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/04.
//

import Foundation

class WeatherService {
    
    var weather: WeatherModel = WeatherModel() {
        didSet {
            DispatchQueue.main.async {
                
//
//                //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
//                self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)
                
            }
        }
    }
    
    var todayDate: String = DateCalculate.todayDateString
    var yesterdayDate: String = DateCalculate.yesterdayDateString
    var tomorrowDate: String = DateCalculate.tomorrowDateString
    var nowtime: String = TimeCalculate.nowTimeString
    
    func fetchWeatherData(date: String, time: String, nx: String, ny: String, completion: @escaping ([WeatherItem]) -> Void) {
        WeatherDataManager.shared.fetchWeather(date: date, time: time, nx: nx, ny: ny) { result in
            switch result {
            case .success(let weathers):

                
                // 컴플리션 전달
                completion(weathers)
                DispatchQueue.main.async {

                    //ui변경 시 여기서... 아마 ViewModel하고 이어주면 될듯
//                self.todayWeatherView.viewModel = TodayWeatherViewModel(weather: self.weather)

                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sortWeatherCategory(weatherItems: [WeatherItem]) -> Void {
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

    }
    
}

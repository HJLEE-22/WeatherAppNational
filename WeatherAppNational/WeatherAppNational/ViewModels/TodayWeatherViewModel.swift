//
//  WeatherDataViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/25.
//



import UIKit

// 프로토콜 전달 버전
/*
protocol WeatherViewModel {
    func updateWeather()
}
 */

struct TodayWeatherViewModel {

    var weather: WeatherModel
    
    init(weather: WeatherModel) {
        self.weather = weather
    }
    
    var todayWeatherImage: UIImage {
        switch weather.rainingStatus {
        case RainStatusCategory.noRain.rawValue :
            // nested switch 는 오류 야기 가능성이 높다?
            switch weather.skyStatus {
            case SkyCategory.sunny.rawValue :
                return UIImage(systemName: WeatherSystemName.sunMax)!
            case SkyCategory.cloudy.rawValue :
                return UIImage(systemName: WeatherSystemName.cloudSun)!
            case SkyCategory.gray.rawValue :
                return UIImage(systemName: WeatherSystemName.cloud)!
            default :
                break
            }
        case RainStatusCategory.raining.rawValue :
            return UIImage(systemName: WeatherSystemName.cloudRain)!
        case RainStatusCategory.rainingAndSnowing.rawValue :
            return UIImage(systemName: WeatherSystemName.cloudSleet)!
        case RainStatusCategory.snowing.rawValue :
            return UIImage(systemName: WeatherSystemName.cloudSnow)!
        case RainStatusCategory.showering.rawValue :
            return UIImage(systemName: WeatherSystemName.cloudHeavyRain)!
        default :
            break
        }
        return UIImage(systemName: "sparkles")!
    }
    
    var todayDegreeLabel: NSAttributedString {

        guard let degree = weather.temperaturePerHour else { return NSAttributedString(string: "0")}
        let degreeIcon = "°C"
        let attributedText = NSMutableAttributedString(string: degree, attributes: [.font:UIFont.boldSystemFont(ofSize: 60)])
        attributedText.append(NSAttributedString(string: degreeIcon, attributes: [.font:UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.gray]))
        return attributedText
    }
    
    var todayMinDegreeLabel: String {
        guard let min = weather.temperatureMin else { return "0" }
        return min
    }
    
    var todayMaxDegreeLabel: String {
        guard let max = weather.temperatureMax else { return "0" }
        return max
    }
    
    var todayHumidity: String {
        guard let humidity = weather.humidityStatus else { return "0" }
        return humidity
    }
    
    var todayWindSpeed: String {
        guard let wind = weather.windSpeed else { return "0" }
        return wind
    }
    
    // 어제자 weather의 temperaturePerHour 을 가져와서 빼야됨...
    var todayDegreeDescription: String {
        guard let degree = weather.temperaturePerHour else { return "0" }
        return "어제보다 \(degree)°C 추워요"
    }

    var gpsOn: Bool = false
    
    // 현재 위치 정보를 받아왔는지의 여부
    var gpsOnButton: UIImage {
        return gpsOn ? UIImage(systemName: SystemIconNames.gpsOn)! : UIImage(systemName: SystemIconNames.gpsOff)!
    }
    
    // view 배경색 변경
    var viewBackgroundColor: UIColor {
        return UIColor.white
    }
    
}



//
//  YesterdayWeatherViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/28.
//

import UIKit

struct YesterdayWeatherViewModel {
    
    var weather: WeatherModel
    
    
    // 날짜를 가져와야 하는데, 이거 일단 데이터 받는것부터 설정해놓고 하자
//    var dateLabel: NSAttributedString {
//        let yesterday = "어제"
//        let yesterdayDate =
//
//
//    }
//
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
    
    
}

//
//  WeatherModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/26.
//

import UIKit

enum WeatherItemCategory: String {
    case rainingStatus = "PTY"
    case skyStatus = "SKY"
    case humidityStatus = "REH"
    case temperaturePerHour = "TMP"
    case temperatureMax = "TMX"
    case temperatureMin = "TMN"
    case windSpeed = "WSD"
}

enum SkyCategory: String, CaseIterable {
    case sunny = "1"
    case cloudy = "3"
    case gray = "4"
}

enum RainStatusCategory: String, CaseIterable {
    case noRain = "0"
    case raining = "1"
    case rainingAndSnowing = "2"
    case snowing = "3"
    case showering = "4"
}

struct WeatherModel {
    var humidityStatus: String?
    var temperatureMax: String?
    var temperatureMin: String?
    var temperaturePerHour: String?
    var windSpeed: String?
    var rainingStatus: String?
    var skyStatus: String?
}



//
//  Constants.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import Foundation

public struct CellID {
    static let forCitiesCell = "CitiesCellID"
    static let forCitiesListCell = "CitiesListCellID"
    static let forSettingsCell = "SettingsCellID"
    private init() {}
}

public struct WeatherSystemName {
    static let sunMax = "sun.max"
    static let cloudSun = "cloud.sun"
    static let cloud = "cloud"
    static let cloudRain = "cloud.rain"
    static let cloudSleet = "cloud.sleet"
    static let cloudSnow = "cloud.snow"
    static let cloudHeavyRain = "cloud.heavyrain"
    private init() {}
}


public struct SystemIconNames {
    static let gpsOn = "location.fill"
    static let gpsOff = "location"
    private init () {}
}

public struct CoreDataNames {
    static let entityName = "LocationGridData"
    static let sortDescriptorName = "city"
    static let fileName = "LocationData"
    static let fileType = "json"
    private init () {}
}

public struct ImageSystemNames {
    static let star = "star"
    static let starFill = "star.fill"
}

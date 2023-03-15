//
//  Constants.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore


public struct CellID {
    static let forCitiesCell = "CitiesCellID"
    static let forCitiesListCell = "CitiesListCellID"
    static let forSettingsCell = "SettingsCellID"
    static let forProfileCell = "ProfileCellID"
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
    static let update = "arrow.counterclockwise"
    static let gpsOn = "location.fill"
    static let gpsOff = "location"
    static let star = "star"
    static let starFill = "star.fill"
    static let listDash = "list.dash"
    static let gearShape = "gearshape"
    private init () {}
}

public struct CoreDataNames {
    static let entityName = "LocationGridData"
    static let sortDescriptorName = "city"
    static let fileName = "LocationDataWithGPS"
    static let fileType = "json"
    private init () {}
}

// 기상청 api 통신을 위한 Constants
public enum Day {
    case today
    case yesterday
    case tomorrow
}

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



// firestore collection address
let COLLECTION_USERS = Firestore.firestore().collection("users")
let collectionChats = Firestore.firestore().collection("chats")


// firebase realtime database address
let reference = Database.database().reference().child("chats")


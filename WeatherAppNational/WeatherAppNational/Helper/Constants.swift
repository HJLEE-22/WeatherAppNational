//
//  Constants.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import Foundation
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


public enum Day {
    case today
    case yesterday
    case tomorrow
}

public struct UserDefaultsKeys {
    static let launchedBefore = "launchedBefore"
}


let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
//let COLLECTION_UID = Firestore.firestore().collection("users").where("uid", "==", "gusDdKDcvudP9dhAjzbEU4GdQCp1")
    

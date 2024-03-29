//
//  UserDefaultsUtil.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/13.
//

import Foundation

public struct UserDefaultsKeys {
    static let launchedBefore = "launchedBefore"
    static let userModel = "userModel"
    static let isUserDataExist = "isUserDataExist"
    static let cities = "cities"
    static let blockedUserUids = "blockedUserUids"
}

struct UserDefaultsUtil {
    
    static let shared = UserDefaultsUtil()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    
//    enum KeysForUserDefaults: String {
//        case cities
//    }
    
//    func setCities(_ city: [CityModel]) {
//        if let encoded = try? encoder.encode(city) {
//            defaults.set(encoded, forKey: UserDefaultsKeys.cities)
//        }
//    }
//
//    func getCities() -> [CityModel]? {
//        if let savedData = defaults.value(forKey: UserDefaultsKeys.cities) as? Data,
//           let cities = try? JSONDecoder().decode([CityModel].self, from: savedData){
//            return cities
//        }
//        return nil
//    }
    
    
    
}

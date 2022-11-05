//
//  UserDefaultsUtil.swift
//  WeatherAppNational
//
//  Created by Mingu Seo on 2022/11/05.
//

import Foundation

struct UserDefaultsUtil {
    
    static let shared = UserDefaultsUtil()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    
    enum KeysForUserDefaults: String {
        case cities
    }
    
    func setCities(_ city: [CityModel]) {
        if let encoded = try? JSONEncoder().encode(city) {
            defaults.set(encoded, forKey: KeysForUserDefaults.cities.rawValue)
        }
    }
    
    func getCities() -> [CityModel]? {
        if let savedData = defaults.value(forKey: KeysForUserDefaults.cities.rawValue) as? Data,
           let cities = try? JSONDecoder().decode([CityModel].self, from: savedData) {
            return cities
        }
        return nil
    }
}

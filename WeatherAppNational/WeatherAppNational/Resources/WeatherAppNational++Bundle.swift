//
//  WeatherAppNational++Bundle.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/24.
//

import Foundation

extension Bundle {
    var nationalWeatherApiKey: String {
        guard let file = self.path(forResource: "APIKeyList", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["NationalWeatherServiceKey"] as? String else { fatalError("APIKeyList에 API_KEY 설정을 해주세요") }
        return key
    }
}

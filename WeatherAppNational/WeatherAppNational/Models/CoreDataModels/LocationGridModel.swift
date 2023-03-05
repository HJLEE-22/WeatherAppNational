//
//  LocationGridModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/04.
//

import UIKit

struct LocationGridModel: Codable {
    var city: String?
    var district: String?
    var gridX: Int16
    var gridY: Int16
    var bookmark: Bool = false
    var latitude: Double
    var longitude: Double
    
}

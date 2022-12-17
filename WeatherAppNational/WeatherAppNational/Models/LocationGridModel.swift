//
//  LocationGridModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/04.
//

import UIKit

// decoder를 위한 model
// 이걸 개별적으로 사용하진 않는다. 
// 실 사용은 coreData에 저장된 LocationGridData를 사용할 것

struct LocationGridModel: Codable {
    var city: String?
    var district: String?
    var gridX: Int16
    var gridY: Int16
    var bookmark: Bool = false
    var updatedDate: Date?
}

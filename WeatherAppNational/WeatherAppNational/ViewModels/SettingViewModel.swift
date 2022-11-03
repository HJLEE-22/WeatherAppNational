//
//  SettingViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/01.
//

import UIKit
import CoreLocation

struct SettingViewModel {
    
    var isSwitchButtonOn: Bool {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            return true
        } else {
            return false
        }
    }
    

    
    
    
    
}

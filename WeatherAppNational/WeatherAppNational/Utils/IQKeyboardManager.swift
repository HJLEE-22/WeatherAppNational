//
//  IQKeyboardManager.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/30.
//

import Foundation
import IQKeyboardManagerSwift

class IQKeyboardManagerObject {
    static func setting() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 0
    }
    
}

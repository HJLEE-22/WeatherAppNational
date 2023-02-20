//
//  Observer.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/07.
//

import Foundation

protocol Observer {
    func update<T>(updateValue: T)
}

protocol ColorsObserver {
    func colorsUpdate<T>(updateValue: T)
}

protocol WeatherKitObserver {
    func weatherKitUpdate<T>(updateValue: T)
}

protocol UserObserver {
    func userUpdate<T>(updateValue: T)
}

protocol ChatObserver {
    func chatUpdate<T>(updateValue: T)
}

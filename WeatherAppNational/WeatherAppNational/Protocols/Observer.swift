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


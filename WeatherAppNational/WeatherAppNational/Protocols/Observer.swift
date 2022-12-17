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

protocol ViewModelObserver {
    func update<T>(updateValue: T)
    func isEqual(_ object: ViewModelObserver) -> Bool
}

extension ViewModelObserver where Self: Equatable {
    func isEqual(to: ViewModelObserver) -> Bool {
        return (to as? Self).flatMap({ $0 == self}) ?? false
    }
}

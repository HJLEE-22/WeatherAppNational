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

protocol ViewModelObserver: Equatable {
    var uuid: UUID { get set }
    func update<T>(updateValue: T)
}

extension ViewModelObserver {
    static func ==(lhs: any ViewModelObserver, rhs: any ViewModelObserver) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

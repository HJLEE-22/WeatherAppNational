//
//  Observer.swift
//  WeatherAppNational
//
//  Created by Mingu Seo on 2022/11/05.
//

import Foundation

protocol Observer {
    func update<T>(updatedValue: T)
}

protocol ViewModelObserver {
    func update<T>(updatedValue: T)
}

protocol Subscriber {
    var observer: (any Observer)? { get set }
    mutating func unSubscribe(observer: (any Observer)?)
    mutating func subscribe(observer: (any Observer)?)
    func notify<T>(updatedValue: T)
}

protocol UserDefaultsServiceSubscriber {
    var observer: (any ViewModelObserver)? { get set }
    mutating func unSubscribe(observer: (any ViewModelObserver)?)
    mutating func subscribe(observer: (any ViewModelObserver)?)
    func notify<T>(updatedValue: T)
}

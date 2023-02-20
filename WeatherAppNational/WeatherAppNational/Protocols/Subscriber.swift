//
//  Subscriber.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/07.
//

import Foundation

protocol Subscriber {
    var observer: (any Observer)? { get set }
    mutating func subscribe(observer: (any Observer)?)
    mutating func unSubscribe(observer: (any Observer)?)
    func notify<T>(updateValue: T)
}

protocol ColorsSubscriber {
    var colorsObserver: (any ColorsObserver)? { get set }
    mutating func colorsSubscribe(observer: (any ColorsObserver)?)
    mutating func colorsUnsubscribe(observer: (any ColorsObserver)?)
    func colorsNotify<T>(updateValue: T)
}

protocol WeatherKitSubcriber {
    var observer: (any WeatherKitObserver)? { get set }
    mutating func subscribe(observer: (any WeatherKitObserver)?)
    mutating func unsubscribe(observer: (any WeatherKitObserver)?)
    func notify<T>(updateValue: T)
}

protocol UserSubcriber {
    var observer: (any UserObserver)? { get set }
    mutating func subscribe(observer: (any UserObserver)?)
    mutating func unsubscribe(observer: (any UserObserver)?)
    func notify<T>(updateValue: T)
}

protocol ChatSubscriber {
    var observer: (any ChatObserver)? { get set }
    mutating func subscribe(observer: (any ChatObserver)?)
    mutating func unsubscribe(observer: (any ChatObserver)?)
    func notify<T>(updateValue: T)
}

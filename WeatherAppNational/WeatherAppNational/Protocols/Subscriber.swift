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
    mutating func colorsUnSubscribe(observer: (any ColorsObserver)?)
    func colorsNotify<T>(updateValue: T)
}

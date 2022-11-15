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

protocol UserDefaultsSubscriber {
    var observer: (any ViewModelObserver)? { get set }
    mutating func subscribe(obserVer: (any ViewModelObserver)?)
    mutating func unSubscribe(obserVer: (any ViewModelObserver)?)
    func notify<T>(updateValue: T)
}

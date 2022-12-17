//
//  HomeViewModel.swift
//  WeatherAppNational
//
//  Created by Mingu Seo on 2022/12/17.
//

import Foundation

class HomeViewModel {
    var uuid: UUID = UUID()
    var observer: (any Observer)? {
        didSet {
            bind()
        }
    }
    
    init() {
        CoreDataManager.shared.subscribe(observer: self as (any ViewModelObserver))
        
    }
    
    func bind() {
        getBookmarkedLocationGridList()
    }
    
    private func getBookmarkedLocationGridList() {
        let bookmarkedCities = CoreDataManager.shared.getBookmarkedLocationGridList()
        observer?.update(updateValue: bookmarkedCities)
    }
    
}

// MARK: - Subscriber 선언
extension HomeViewModel: Subscriber {
    func subscribe(observer: (Observer)?) {
        self.observer = observer
    }
    
    func unSubscribe(observer: (Observer)?) {
        self.observer = nil
    }
    
    func notify<T>(updateValue: T) {
        observer?.update(updateValue: updateValue)
    }
}


extension HomeViewModel: ViewModelObserver {
    static func == (lhs: HomeViewModel, rhs: HomeViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func update<T>(updateValue: T) {
        notify(updateValue: updateValue)
    }
}

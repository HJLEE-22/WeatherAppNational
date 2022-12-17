//
//  CitiesViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/06.
//

import UIKit

class CitiesViewModel {
    
    // MARK: - Properties
    
    var observer: (any Observer)?
    
    private var locationGridDatas: [LocationGridData]? = [LocationGridData]() {
        didSet {
            notify(updateValue: locationGridDatas)
        }
    }
    
    // MARK: - Lifecycle
    
    init() {
        self.bindLocationGridData()
    }
    
    func bindLocationGridData() {
        locationGridDatas = getBookmarkedLocationGridForViewModel()
    }
    
    func updateLocationGridsBookmark(_ locationGridData: LocationGridData) {
        CoreDataManager.shared.updateLocationGridData(newLocationGridData: locationGridData) { [weak self] in
//            self?.locationGridDatas = self?.getBookmarkedLocationGrid()
        }
    }
    // 외부 return용
    func getLocationGrid() -> [LocationGridData] {
        guard let locationGridDatas = locationGridDatas else { return [] }
        return locationGridDatas
    }

    func getBookmarkedByViewModel() -> [LocationGridData] {
        guard let locationGridDatas = locationGridDatas else { return [] }
        let datas = CoreDataManager.shared.getBookmarkedLocationGridList()
        self.locationGridDatas = datas
        return locationGridDatas
    }

    // viewModel 내부용
    func getLocationGridForViewMdodel() {
        self.locationGridDatas = CoreDataManager.shared.getLocationGridList()
    }

    func getBookmarkedLocationGridForViewModel() -> [LocationGridData] {
        CoreDataManager.shared.getBookmarkedLocationGridList()
    }
    
    func getFilteredLocationGrid(by locationName: String) {
        self.locationGridDatas = CoreDataManager.shared.getFilteredLocationGridList(by: locationName)
    }
}

extension CitiesViewModel: Subscriber {
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



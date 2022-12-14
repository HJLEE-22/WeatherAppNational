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
    
    var parameterForFiltering: String?
    var bookmarkBool: Bool?
    
    // 여기서 ViewModel을 초기화시 필요한 속성은 무엇일까?
    // 내가 반환할건 [locationModel]이고, 이걸 정제해야 한다.
    // 그러면 필요한 건 1. searchBar에서 검색 내용을 보여주기 위한 filter String input
    // 2. bookmark된 날씨들을 위한 bookmark 여부
    // 내가 사용하는 데이터는? 코어데이터에 저장한 데이터를 가져오는건 [LocationGridData]가 맞다.
    // 근데 필터링해서 내보내는 데이터도 저건가? 아니면 다른 임의의 location 모델을 추가로 만들어야 하나?
    // 이런 고민으로 만들어놓은게 LocationModel.
    // (우선 searchsBar 검색만을 위해 city/district만 구현해놓음)
    // 근데 그럴 필요가 없는 것 같기도 하고.
    
    // 근데 bookmark값을 인자로 받는건 이상함.
    // 이건 버튼을 누를때마다 바뀌는데, 그때마다 인자를 새로 넣어 값을 호출해야 하나?
    
    // MARK: - Lifecycle
    
    init(parameterForFiltering: String?, bookmarkBool: Bool?) {
        self.parameterForFiltering = parameterForFiltering
        self.bookmarkBool = bookmarkBool
        self.bind()
    }
    
    func bind() {
        
        locationGridDatas = getLocationGrid()

        if let parameterForFiltering = parameterForFiltering {
            getWeatherDataDependingText(parameterForFiltering)
        }
        updateLocationGridsByBookmark(bookmark: bookmarkBool)

    }
    
    func updateLocationGridsByBookmark(bookmark: Bool?) {
        if bookmark == true {
            locationGridDatas = getLocationGrid().filter({ $0.bookmark == true })
        } else if bookmark == false {
            locationGridDatas = getLocationGrid().filter({ $0.bookmark == false })
        } else {
            locationGridDatas = getLocationGrid()
        }
    }
    
    func getLocationGrid() -> [LocationGridData] {
        CoreDataManager.shared.getLocationGridListFromCoreData()
    }
    
    func getWeatherDataDependingText(_ text: String) {
        if text.isEmpty {
            locationGridDatas = getLocationGrid()
        } else {
            locationGridDatas = getLocationGrid().filter({ $0.city!.contains(text) || $0.district!.contains(text) })
        }
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



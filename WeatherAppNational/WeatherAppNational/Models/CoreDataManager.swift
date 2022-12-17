//
//  CoreDataManager.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/04.
//

import UIKit
import CoreData

//MARK: - To do 관리하는 매니저 (코어데이터 관리)

final class CoreDataManager: CoreDataSubscriber {
    var observers: ([ViewModelObserver])?
    
    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = CoreDataNames.entityName
    let sortDescriptorName: String = CoreDataNames.sortDescriptorName
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveLocationGridData(locationGrid: LocationGridModel, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                if let locationGridData = NSManagedObject(entity: entity, insertInto: context) as? LocationGridData {
                    
                    // MARK: - LocationGridData에 실제 데이터 할당 ⭐️
                    locationGridData.city = locationGrid.city
                    locationGridData.district = locationGrid.district
                    locationGridData.gridX = locationGrid.gridX
                    locationGridData.gridY = locationGrid.gridY
                    locationGridData.bookmark = locationGrid.bookmark
                    
                    appDelegate?.saveContext()
                }
            }
        }
        completion()
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getLocationGridList() -> [LocationGridData] {
        var LocationGridList: [LocationGridData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            //                let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            //                request.sortDescriptors = [dateOrder]
            
            let orderForSort = NSSortDescriptor(key: sortDescriptorName, ascending: true)
            request.sortDescriptors = [orderForSort]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedLocationList = try context.fetch(request) as? [LocationGridData] {
                    LocationGridList = fetchedLocationList
                }
            } catch {
                print("DEBUG: 전체대이터 로드 실패")
            }
        }
        return LocationGridList
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 중 북마크 된 것 읽어오기

    func getBookmarkedLocationGridList() -> [LocationGridData] {
        var LocationGridList: [LocationGridData] = []
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let orderForSort = NSSortDescriptor(key: sortDescriptorName, ascending: true)
            request.sortDescriptors = [orderForSort]
            do {
                if let fetchedLocationList = try context.fetch(request) as? [LocationGridData] {
                    LocationGridList = fetchedLocationList.filter({ $0.bookmark == true })
                }
            } catch {
                print("DEBUG: 북마크 데이터 로드 실패")
            }
        }
        return LocationGridList
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 중 도시 이름 filter해 읽어오기
    
    func getFilteredLocationGridList(by locationName: String) -> [LocationGridData] {
        var LocationGridList: [LocationGridData] = []
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let orderForSort = NSSortDescriptor(key: sortDescriptorName, ascending: true)
            request.sortDescriptors = [orderForSort]
            do {
                if let fetchedLocationList = try context.fetch(request) as? [LocationGridData] {
                    LocationGridList = fetchedLocationList.filter({ $0.city!.contains(locationName) || $0.district!.contains(locationName) })
                }
            } catch {
                print("DEBUG: 도시이름 필터 데이터 로드 실패")
            }
        }
        return LocationGridList
    }

   
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateLocationGridData(newLocationGridData: LocationGridData, completion: @escaping () -> Void) {

        guard let cityData = newLocationGridData.city,
              let districtData = newLocationGridData.district,
              let context = context else { return }
        
        // 요청서
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        // 단서 / 찾기 위한 조건 설정
        request.predicate = NSPredicate(format: "city = %@ AND district = %@", cityData, districtData)
        
        do {
            // 요청서를 통해서 데이터 가져오기
            if let fetchedLocationGridList = try context.fetch(request) as? [LocationGridData] {
                // 배열의 첫번째
                if var targetLocationGrid = fetchedLocationGridList.first {
                    
                    // MARK: - LocationGridData에 실제 데이터 재할당(바꾸기) ⭐️
                    targetLocationGrid.bookmark = !targetLocationGrid.bookmark
                    appDelegate?.saveContext()
                }
            }
            completion()
        } catch {
            print("update 실패")
            completion()
        }
    }
}

extension CoreDataManager {
    func subscribe(observer: (any ViewModelObserver)?) {
        guard var observers = observers,
              let observer = observer
        else { return }
        
        observers.append(observer)
    }
    
    func unSubscribe(observer: (any ViewModelObserver)?) {
        guard var observers = observers,
              let observer = observer,
              let index = observers.firstIndex(where: { $0.isEqual(observer)})
        else { return }        
        
        observers.remove(at: index)
    }
    
    func notify<T>(updateValue: T) {
        guard let observers = observers else { return }
        
        observers.forEach {
            $0.update(updateValue: updateValue)
        }
    }
}

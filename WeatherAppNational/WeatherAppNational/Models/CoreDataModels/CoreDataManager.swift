//
//  CoreDataManager.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/04.
//

import UIKit
import CoreData

//MARK: - To do 관리하는 매니저 (코어데이터 관리)

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = CoreDataNames.entityName
    let sortDescriptorName: String = CoreDataNames.sortDescriptorName
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveLocationGridData(locationGrid: LocationGridModel, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                if let locationGridData = NSManagedObject(entity: entity, insertInto: context) as? LocationGridData {
                    
                    // MARK: - LocationGridData에 실제 데이터 할당 ⭐️
                    locationGridData.city = locationGrid.city
                    locationGridData.district = locationGrid.district
                    locationGridData.gridX = locationGrid.gridX
                    locationGridData.gridY = locationGrid.gridY
                    locationGridData.bookmark = locationGrid.bookmark
                    locationGridData.longitude = locationGrid.longitude
                    locationGridData.latitude = locationGrid.latitude
                    appDelegate?.saveContext()
                }
            }
        }
        completion()
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getLocationGridList() -> [LocationGridData] {
        var LocationGridList: [LocationGridData] = []
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let orderForSort = NSSortDescriptor(key: sortDescriptorName, ascending: true)
            request.sortDescriptors = [orderForSort]
            
            do {
                if let fetchedLocationList = try context.fetch(request) as? [LocationGridData] {
                    LocationGridList = fetchedLocationList
                }
            } catch {
                print("DEBUG: 전체데이터 로드 실패")
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
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "city = %@ AND district = %@", cityData, districtData)
        
        do {
            if let fetchedLocationGridList = try context.fetch(request) as? [LocationGridData] {
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

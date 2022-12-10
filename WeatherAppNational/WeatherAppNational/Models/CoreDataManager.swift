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
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getLocationGridListFromCoreData() -> [LocationGridData] {
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
                print("가져오는 것 실패")
            }
        }
        return LocationGridList
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveLocationGridData(locationGrids: LocationGridModel, completion: @escaping () -> Void) {
            // 임시저장소 있는지 확인
            if let context = context {
                // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
                if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                    
                    // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                    if let locationGridData = NSManagedObject(entity: entity, insertInto: context) as? LocationGridData {
                        
                        // MARK: - LocationGridData에 실제 데이터 할당 ⭐️
                        locationGridData.city = locationGrids.city
                        locationGridData.district = locationGrids.district
                        locationGridData.gridX = locationGrids.gridX
                        locationGridData.gridY = locationGrids.gridY
                        locationGridData.bookmark = locationGrids.bookmark
                        
                        appDelegate?.saveContext()
                    }
                }
            }
            completion()
        }
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
        func updateLocationGridData(newLocationGridData: LocationGridData, completion: @escaping () -> Void) {
            // 날짜 옵셔널 바인딩
//            guard let cityData = newLocationGridData.city,
//                  let distrcitData = newLocationGridData.district else {
//                completion()
//                return
//            }
            
            // 임시저장소 있는지 확인
            if let context = context {
                // 요청서
                let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                // 단서 / 찾기 위한 조건 설정
// 🥵 predicate 양식 확인 필요...
                request.predicate = NSPredicate(format: "city = %@ && district = %@", newLocationGridData)

                do {
                    // 요청서를 통해서 데이터 가져오기
                    if let fetchedLocationGridList = try context.fetch(request) as? [LocationGridData] {
                        // 배열의 첫번째
                        if var targetLocationGrid = fetchedLocationGridList.first {

                            // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                            targetLocationGrid = newLocationGridData
                            let orderSort = NSSortDescriptor(key: sortDescriptorName, ascending: true)
                            request.sortDescriptors = [orderSort]
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
}

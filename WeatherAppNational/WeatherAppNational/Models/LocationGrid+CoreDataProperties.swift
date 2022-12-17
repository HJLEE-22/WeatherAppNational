//
//  LocationGrid+CoreDataProperties.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/04.
//
//

import Foundation
import CoreData


extension LocationGridData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationGridData> {
        return NSFetchRequest<LocationGridData>(entityName: "LocationGridData")
    }

    @NSManaged public var gridY: Int16
    @NSManaged public var gridX: Int16
    @NSManaged public var district: String?
    @NSManaged public var city: String?
    @NSManaged public var bookmark: Bool
    @NSManaged public var updatedDate: Date?

}

extension LocationGridData : Identifiable {

}

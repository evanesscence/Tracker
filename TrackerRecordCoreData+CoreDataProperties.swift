//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Karina ❦ on 18.06.2024.
//
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?

}

extension TrackerRecordCoreData : Identifiable {

}

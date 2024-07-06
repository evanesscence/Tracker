//
//  TrackerCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Karina ❦ on 18.06.2024.
//
//

import Foundation
import CoreData


extension TrackerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var color: String?
    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var schedule: Int32
    @NSManaged public var category: NSSet?

}

// MARK: Generated accessors for category
extension TrackerCoreData {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: TrackerCategoryCoreData)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: TrackerCategoryCoreData)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

extension TrackerCoreData : Identifiable {

}

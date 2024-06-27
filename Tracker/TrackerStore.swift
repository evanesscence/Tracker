import UIKit
import CoreData

protocol TrackerStoreProtocol: AnyObject {
    func add(tracker: Tracker, with category: String) throws
}

private enum TrackerStoreError: Error {
    case decodingErrorInvalidTracker
    case failRequest
}

final class TrackerStore: TrackerStoreProtocol {
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    public func add(tracker: Tracker, with category: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color.toHexString()
        trackerCoreData.schedule = convertToInt(schedule: tracker.schedule)
        
        if let trackerCategory = TrackerCategoryStore().fetchCategoryName(category) {
            trackerCoreData.category = NSSet(object: trackerCategory) 
        }
        
        try context.save()
    }
    
    func convertToTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard
            let id = trackerCoreData.id,
            let name = trackerCoreData.name,
            let emoji = trackerCoreData.emoji,
            let color = trackerCoreData.color
        else {
            throw TrackerStoreError.decodingErrorInvalidTracker
        }
        
        let convertColor = UIColor(hexString: color)
        let convertToDay = converToDay(days: trackerCoreData.schedule)
        
        let tracker = Tracker(
            id: id,
            name: name,
            color: convertColor,
            emoji: emoji,
            schedule: convertToDay)
        
        return tracker
    }
    
    func convertToInt(schedule: [DaysOfWeek]) -> Int32 {
        var days = ""
        schedule.forEach { day in
           days += String(day.day.rawValue)
        }
        
        return Int32(days) ?? 0
    }
    
    func converToDay(days: Int32) -> [DaysOfWeek] {
        let a = String(days)
        let numbers = a.compactMap { $0.wholeNumberValue }
        var daysarr = [DaysOfWeek]()
        
        numbers.forEach {
            guard let day = Days(rawValue: $0) else { return }
            daysarr.append(DaysOfWeek(day: day, isOn: true))
            
        }
        
        return daysarr
    }
    
    func idsFetch(id: UUID) throws -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        guard let items = try? context.fetch(request) else { throw TrackerStoreError.failRequest }
        return items.first
    }
   
}

extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}

extension TrackerStore: DataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
}



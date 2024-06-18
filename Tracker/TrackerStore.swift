import UIKit
import CoreData

final class TrackerStore {
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
        trackerCoreData.schedule = 2345
    
        try context.save()
        
        print(trackerCoreData.id)
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
    
    func fetch() {
        let fet = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        fet.propertiesToFetch = ["name"]
        fet.resultType = .dictionaryResultType
            let book = try! context.execute(fet) as! NSAsynchronousFetchResult<NSFetchRequestResult>
            print(book.finalResult)
        
    }
   
}

extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}



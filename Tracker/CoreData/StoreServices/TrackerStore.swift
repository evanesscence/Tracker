import UIKit
import CoreData

protocol TrackerStoreProtocol: AnyObject {
    func add(tracker: Tracker, with category: String) throws
    func edit(tracker: Tracker, with category: String) throws
}

private enum TrackerStoreError: Error {
    case decodingErrorInvalidTracker
    case failRequest
}

final class TrackerStore: NSObject, TrackerStoreProtocol {
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            fatalError("Не удалось получить AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: false) ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    
 
    public func getPinnedTrackerCategoryName(with trackerID: UUID) -> String? {
        let tracker = try? idsFetch(id: trackerID)
        return isPinnedTracker(with: trackerID) ? tracker?.categoryName : nil
    }
    
    public func isPinnedTracker(with trackerID: UUID) -> Bool {
        let tracker = try? idsFetch(id: trackerID)
        
        if let pinned = tracker?.isPinned {
            return pinned
        }
        
        return false
    }
    
    public func pinnedTracker(with trackerID: UUID) {
        let pinnedTrackerName = NSLocalizedString("pinnedTracker", comment: "")
        let tracker = try? idsFetch(id: trackerID)
        
        tracker?.categoryName = tracker?.category?.name
        tracker?.isPinned = true
        
        if let pinned = try? TrackerCategoryStore().fetchCategoryByName(pinnedTrackerName) {
            tracker?.category = pinned
        } else {
            try? TrackerCategoryStore().addNewCategory(TrackerCategory(name: pinnedTrackerName, trackers: []))
            if let pinned = try? TrackerCategoryStore().fetchCategoryByName(pinnedTrackerName) {
                tracker?.category = pinned
            }
        }
        
        try? context.save()
    }
    
    public func unpinnedTracker(with trackerID: UUID) {
        let tracker = try? idsFetch(id: trackerID)
        tracker?.isPinned = false
        
        if let categoryName = tracker?.categoryName {
            let lastCategoryName = try? TrackerCategoryStore().fetchCategoryByName(categoryName)
            tracker?.category = lastCategoryName
        }
        
        try? context.save()
    }
    
    public func add(tracker: Tracker, with category: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color.toHexString()
        trackerCoreData.schedule = convertToInt(schedule: tracker.schedule)
        
        if let trackerCategoryCoreData = try TrackerCategoryStore().fetchCategoryByName(category) {
            trackerCoreData.category = trackerCategoryCoreData
        } else {
            throw TrackerStoreError.decodingErrorInvalidTracker
        }
        
        try context.save()
    }
    
    public func edit(tracker: Tracker, with category: String) throws {
        let trackerCoreData = try? idsFetch(id: tracker.id)
  
        trackerCoreData?.name = tracker.name
        trackerCoreData?.emoji = tracker.emoji
        trackerCoreData?.color = tracker.color.toHexString()
        trackerCoreData?.schedule = convertToInt(schedule: tracker.schedule)
        
        if isPinnedTracker(with: tracker.id) {
            trackerCoreData?.category?.name = NSLocalizedString("pinnedTracker", comment: "")
            trackerCoreData?.categoryName = category
        } else {
            if let trackerCategoryCoreData = try TrackerCategoryStore().fetchCategoryByName(category) {
                trackerCoreData?.category = trackerCategoryCoreData
            } else {
                throw TrackerStoreError.decodingErrorInvalidTracker
            }
        }
        
        try context.save()
    }
    
    public func delete(tracker: Tracker) {
        guard let trackerCoreData = try? idsFetch(id: tracker.id) else { return }
        context.delete(trackerCoreData)
        
        try? context.save()
    }
    
    public func fetchTracker(by id: UUID) throws -> Tracker? {
        if let trackerCoreData = try idsFetch(id: id) {
            return try convertToTracker(trackerCoreData)
        }
        return nil
    }
    
    private func convertToTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
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
    
    private func convertToInt(schedule: [DaysOfWeek]) -> Int32 {
        var days = ""
        schedule.forEach { day in
           days += String(day.day.rawValue)
        }
        
        return Int32(days) ?? 0
    }
    
    private func converToDay(days: Int32) -> [DaysOfWeek] {
        let a = String(days)
        let numbers = a.compactMap { $0.wholeNumberValue }
        var daysarr = [DaysOfWeek]()
        
        numbers.forEach {
            guard let day = Days(rawValue: $0) else { return }
            daysarr.append(DaysOfWeek(day: day, isOn: true))
            
        }
        
        return daysarr
    }
    
    private func idsFetch(id: UUID) throws -> TrackerCoreData? {
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

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) { }
}







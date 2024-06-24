import UIKit
import CoreData



private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidCategoryTitle
    case decodingErrorInvalidCategoryTrackers
}

final class TrackerCategoryStore {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        
        trackerCategoryCoreData.name = category.name
        try context.save()
    }
    
    func convertToTrackerCategory() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let categoryFromCoreData = try context.fetch(fetchRequest)
        return try categoryFromCoreData.map { try self.convertToTrackerCategory(from: $0) }
    }
    
    func convertToTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let categoryTitle = trackerCategoryCoreData.name else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTitle
        }
        
        guard let trackersList = trackerCategoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
        }
        
        let categoryTrackers = try trackersList.compactMap { trackerCoreDate in
            guard let tracker = try? TrackerStore().convertToTracker(trackerCoreDate) else {
                throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
            }
            return tracker
        }
        
        
        return TrackerCategory(
            name: categoryTitle,
            trackers: categoryTrackers)
        
    }
    
    func fetchCategoryName(_ name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
        
        let category = try! context.fetch(request)
        
        if category.count > 0 { return category[0] } else { return nil }
    }
}

extension TrackerCategoryStore: DataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
}

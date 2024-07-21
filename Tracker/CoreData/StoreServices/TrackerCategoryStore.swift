import UIKit
import CoreData

protocol TrackerCategoryStoreProtocol: AnyObject {
    func addNewCategory(_ category: TrackerCategory) throws
    func convert(_ name: String) throws -> TrackerCategory?
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore, with insertedIndex: IndexSet)
}


private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidCategoryTitle
    case decodingErrorInvalidCategoryTrackers
}

final class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    weak var delegate: TrackerCategoryStoreDelegate?
    static let shared = TrackerCategoryStore()
    let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
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
    
    var trackersCD: [TrackerCategoryCoreData] {
        let predicate = NSPredicate(format: "%K != %@", #keyPath(TrackerCategoryCoreData.name), NSLocalizedString("pinnedTracker", comment: ""))
        fetchedResultsController.fetchRequest.predicate = predicate
        try? fetchedResultsController.performFetch()
        
        return self.fetchedResultsController.fetchedObjects ?? []
    }
    
    var trackers: [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        
        let trackersCategory = objects.compactMap { coreDataObject -> TrackerCategory? in
            guard let name = coreDataObject.name else {
                return nil
            }
            return try? TrackerCategoryStore().convert(name)
        }
        return trackersCategory
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = category.name
        try context.save()
    }
    
    private func convertToTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let categoryTitle = trackerCategoryCoreData.name else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTitle
        }
        
        guard let trackersSet = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
        }
        
        let trackersList = trackersSet.compactMap { $0 as? TrackerCoreData }
        
        let categoryTrackers = try trackersList.compactMap { trackerCoreData in
            if let trackerId = trackerCoreData.id, let tracker = try? TrackerStore().fetchTracker(by: trackerId) {
                return tracker
            } else {
                throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
            }
        }
        
        return TrackerCategory(
            name: categoryTitle,
            trackers: categoryTrackers
        )
    }
    
    func fetchCategoryByName(_ name: String) throws -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
        
        do {
            let category = try context.fetch(request)
            if category.count > 0 {
                return category[0]
            } else {
                return nil
            }
        } catch {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
        }
    }
    
    func convert(_ name: String) throws -> TrackerCategory? {
        do {
            if let trackerCategoryCoreData = try? fetchCategoryByName(name) {
                return try convertToTrackerCategory(from: trackerCategoryCoreData)
            }
        } catch {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
        }
        return nil
    }
}

extension TrackerCategoryStore: DataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { 
        insertedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let insertedIndexes else { return }
        
        
        delegate?.storeDidUpdate(self, with: insertedIndexes)
        self.insertedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) { 
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        default:
            break
        }
    }
}





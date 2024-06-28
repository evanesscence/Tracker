import UIKit
import CoreData

final class TrackerCategoryDataProvider: NSObject {
    private let context: NSManagedObjectContext
    private let dataStore: TrackerCategoryStore
    
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
    
    init(_ dataStore: TrackerCategoryStore) {
        guard let context = dataStore.managedObjectContext else { fatalError() }
        self.context = context
        self.dataStore = dataStore
    }
    
    var trackers: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackersCategory = try? objects.map({ try dataStore.convertToTrackerCategory(from: $0) })
        else { return [] }
        return trackersCategory
    }
    
//    var numberOfSections: Int {
//        fetchedResultsController.sections?.count ?? 0
//    }
//    
//    func numberOfRowsInSection(_ section: Int) -> Int {
//        guard !trackers.isEmpty else { return 0 }
//        guard let count = fetchedResultsController.sections?[section].objects?.count else { return 0 }
//        return count
//    }
//    
//    func object(at section: IndexPath) throws -> TrackerCategory? {
//        let trackerCoreData = fetchedResultsController.object(at: section)
//        let trackerCategory = try? dataStore.convertToTrackerCategory(from: trackerCoreData)
//        return trackerCategory
//    }
    
}

extension TrackerCategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

extension TrackerCategoryDataProvider: TrackerCategoryStoreProtocol {
    func addNewCategory(_ category: TrackerCategory) throws {
        try? dataStore.addNewCategory(category)
    }
}

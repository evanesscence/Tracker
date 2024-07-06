//import UIKit
//import CoreData
//
//final class TrackerCategoryDataProvider: NSObject {
//    private let context: NSManagedObjectContext
//    private let dataStore: TrackerCategoryStore
//    
//    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
//        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
//        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: false) ]
//        
//        let controller = NSFetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext,
//            sectionNameKeyPath: nil,
//            cacheName: nil)
//        
//        controller.delegate = self
//        try? controller.performFetch()
//        return controller
//    }()
//    
//    init(_ dataStore: TrackerCategoryStore) {
//        guard let context = dataStore.managedObjectContext else { fatalError() }
//        self.context = context
//        self.dataStore = dataStore
//    }
//    
//    var trackers: [TrackerCategory] {
//        guard let objects = fetchedResultsController.fetchedObjects else {
//            return []
//        }
//        
//        let trackersCategory = objects.compactMap { coreDataObject -> TrackerCategory? in
//            guard let name = coreDataObject.name else {
//                return nil
//            }
//            
//            
//            return try? TrackerCategoryStore().convert(name)
//        }
//        
//        return trackersCategory
//    }
//}
//
//extension TrackerCategoryDataProvider: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        
//    }
//    
//    func controller(
//        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
//        didChange anObject: Any,
//        at indexPath: IndexPath?,
//        for type: NSFetchedResultsChangeType,
//        newIndexPath: IndexPath?
//    ) {
//        
//    }
//}
//
//extension TrackerCategoryDataProvider: TrackerCategoryStoreProtocol {
//    func addNewCategory(_ category: TrackerCategory) throws {
//        try? dataStore.addNewCategory(category)
//    }
//    
//    func convert(_ name: String) throws -> TrackerCategory?  {
//        try? dataStore.convert(name)
//    }
//}

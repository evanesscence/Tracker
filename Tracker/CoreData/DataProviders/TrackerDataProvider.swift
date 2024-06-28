import UIKit
import CoreData

final class TrackerDataProvider: NSObject {
    private let context: NSManagedObjectContext
    private let dataStore: TrackerStore
    
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
    
    init(_ dataStore: TrackerStore) {
        guard let context = dataStore.managedObjectContext else { fatalError() }
        self.context = context
        self.dataStore = dataStore
    }
   
}

extension TrackerDataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

extension TrackerDataProvider: TrackerStoreProtocol {
    func add(tracker: Tracker, with category: String) throws {
        try? dataStore.add(tracker: tracker, with: category)
    }
}

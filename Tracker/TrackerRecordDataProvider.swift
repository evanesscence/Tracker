import UIKit
import CoreData

final class TrackerRecordDataProvider: NSObject {
    private let context: NSManagedObjectContext
    private let dataStore: TrackerRecordStore
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
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
    
    init(_ dataStore: TrackerRecordStore) {
        guard let context = dataStore.managedObjectContext else { fatalError() }
        self.context = context
        self.dataStore = dataStore
    }
    
    func fetchRecords() -> [TrackerRecord] {
        do {
            let records = try dataStore.convertToTrackerRecord()
            return records
        } catch {
            assertionFailure("No tracker records")
            return []
        }
    }
}

extension TrackerRecordDataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

extension TrackerRecordDataProvider: TrackerRecordStoreProtocol {
    func addNewTrackerRecord(for record: TrackerRecord) throws {
        try? dataStore.addNewTrackerRecord(for: record)
    }
}

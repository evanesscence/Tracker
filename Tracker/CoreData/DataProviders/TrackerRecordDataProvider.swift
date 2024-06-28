import UIKit
import CoreData

final class TrackerRecordDataProvider: NSObject {
    private let context: NSManagedObjectContext
    private let dataStore: TrackerRecordStore
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "trackerID", ascending: false) ]
        
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
    
    var records: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try dataStore.convertToTrackerRecord(from: $0) })
        else { return [] }
        return records
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
    
    func deleteTrackerRecord(for record: TrackerRecord) throws {
        try? dataStore.deleteTrackerRecord(for: record)
    }
}

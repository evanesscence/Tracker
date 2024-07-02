import UIKit
import CoreData

protocol TrackerRecordStoreProtocol: AnyObject {
    func addNewTrackerRecord(for record: TrackerRecord) throws
}

final class TrackerRecordStore: NSObject, TrackerRecordStoreProtocol {
    static let shared = TrackerRecordStore()
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
    
    var records: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try convertToTrackerRecord(from: $0) })
        else { return [] }
        return records
    }
    
    func addNewTrackerRecord(for record: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerID = record.id
        trackerRecordCoreData.date = record.date
        
        try context.save()
    }
    
    func deleteTrackerRecord(for record: TrackerRecord) throws {
        let id = record.id
        let date = record.date
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "(%K == %@) AND (%K == %@)",
            #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg,
            #keyPath(TrackerRecordCoreData.date), date as CVarArg)
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
    
    private func convertToTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let date = trackerRecordCoreData.date else {
            preconditionFailure("err")
        }
        
        guard let id = trackerRecordCoreData.trackerID else {
            preconditionFailure("err")
        }
        
        let trackerRecord = TrackerRecord(id: id, date: date)
        return trackerRecord
        
    }
}

extension TrackerRecordStore: DataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
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

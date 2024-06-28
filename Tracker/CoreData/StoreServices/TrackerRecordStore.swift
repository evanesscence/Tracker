import UIKit
import CoreData

protocol TrackerRecordStoreProtocol: AnyObject {
    func addNewTrackerRecord(for record: TrackerRecord) throws
}

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
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
    
    func convertToTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
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

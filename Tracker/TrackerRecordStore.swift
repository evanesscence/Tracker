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
    
    func convertToTrackerRecord() throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let recordsCoreData = try context.fetch(fetchRequest)
        return try recordsCoreData.map { try self.convertToTrackerRecord(from: $0) }
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

import CoreData

protocol DataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? { get }
}

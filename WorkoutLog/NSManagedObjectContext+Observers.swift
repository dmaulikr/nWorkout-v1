import CoreData

public struct ObjectsDidChangeNotification {
    init(note: NSNotification) {
        assert(note.name == NSNotification.Name(rawValue:"NSManagedObjectContextObjectsDidChangeNotification"))
        notification = note
    }
    
    public var insertedObjects: Set<NSManagedObject> {
        return objectsForKey(key: NSInsertedObjectsKey)
    }
    public var updatedObjects: Set<NSManagedObject> {
        return objectsForKey(key: NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: Set<NSManagedObject> {
        return objectsForKey(key: NSDeletedObjectsKey)
    }
    
    public var refreshedObjects: Set<NSManagedObject> {
        return objectsForKey(key: NSRefreshedObjectsKey)
    }
    
    public var invalidatedObjects: Set<NSManagedObject> {
        return objectsForKey(key: NSInvalidatedObjectsKey)
    }
    
    public var invalidatedAllObjects: Bool {
        return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    public var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    // MARK: Private
    
    private let notification: NSNotification
    
    private func objectsForKey(key: String) -> Set<NSManagedObject> {
        return (notification.userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }
}


extension NSManagedObjectContext {
    public func addObjectsDidChangeNotificationObserver(handler: @escaping (ObjectsDidChangeNotification) -> ()) -> NSObjectProtocol {
        let nc = NotificationCenter.default
        return nc.addObserver(forName: Notification.Name(rawValue: "NSManagedObjectContextObjectsDidChangeNotification"), object: self, queue: nil) { note in
            let wrappedNote = ObjectsDidChangeNotification(note: note as NSNotification)
            handler(wrappedNote)
        }
    }
}

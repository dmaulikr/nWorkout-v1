import CoreData

public struct ObjectsDidChangeNotification {
    init(note: NSNotification) {
        assert(note.name == NSNotification.Name(rawValue:"NSManagedObjectContextObjectsDidChangeNotification"))
        notification = note
    }
    
    public var insertedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSInsertedObjectsKey)
    }
    public var updatedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSDeletedObjectsKey)
    }
    
    public var refreshedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSRefreshedObjectsKey)
    }
    
    public var invalidatedObjects: Set<ManagedObject> {
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
    
    private func objectsForKey(key: String) -> Set<ManagedObject> {
        return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
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

import CoreData

public final class ManagedObjectObserver {
    public enum ChangeType {
        case delete
        case update
    }
    
    public init?(object: ManagedObjectType, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        objectHasBeenDeleted = !(type(of: object).defaultPredicate.evaluate(with: object))
        token = moc.addObjectsDidChangeNotificationObserver { [unowned self] note in
            guard let changeType = self.changeTypeOfObject(object: object, inNotification: note) else { return }
            self.objectHasBeenDeleted = changeType == .delete
            changeHandler(changeType)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    private var token: NSObjectProtocol!
    private var objectHasBeenDeleted: Bool = false
    
    private func changeTypeOfObject(object: ManagedObjectType, inNotification note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.containsObjectIdentical(to: object) {
            return .update
        }
        return nil
    }
}

import CoreData

extension NSManagedObjectContext {
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    public func performChanges(block: () -> ()) {
        perform {
            block()
            let _ = self.saveOrRollback()
        }
    }
}

import CoreData

protocol DataProvider: class {
    associatedtype Object: NSManagedObject
    func object(at indexPath: IndexPath) -> Object
    func insert(object: Object) -> IndexPath
    func remove(object: Object)
    func index(of object: Object) -> IndexPath
    func numberOfItems(inSection section: Int) -> Int
    func numberOfSections() -> Int
}

extension DataProvider {
    func index(of object: Object) -> IndexPath {
        assertionFailure("Optional, you must implement this.")
        return IndexPath()
    }
    
    func insert(object: Object) -> IndexPath {
        assertionFailure("Optional, you must implement this.")
        return IndexPath()
    }
    
    func remove(object: Object) {
        fatalError()
    }
}

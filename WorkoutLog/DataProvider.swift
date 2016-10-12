import CoreData

protocol DataProvider: class {
    associatedtype Object: ManagedObject
    //Required
    func object(at indexPath: IndexPath) -> Object
    func numberOfItems(inSection section: Int) -> Int
    func numberOfSections() -> Int
    //Optional
    func insert(object: Object) -> IndexPath
    func remove(object: Object)
    func index(of object: Object) -> IndexPath
    
    func moveObject(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

extension DataProvider {
    func index(of object: Object) -> IndexPath {
        fatalError(#function + "not implemented.")
    }
    
    func insert(object: Object) -> IndexPath {
        fatalError(#function + "not implemented.")
    }
    
    func remove(object: Object) {
        fatalError(#function + "not implemented.")
    }
    func moveObject(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fatalError(#function + "not implemented.")
    }
}

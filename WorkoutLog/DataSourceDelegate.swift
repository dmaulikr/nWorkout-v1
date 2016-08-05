import CoreData

protocol DataSourceDelegate: class {
    associatedtype Object: NSManagedObject
    func cellIdentifier(for object: Object) -> String
}

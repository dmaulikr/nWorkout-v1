import CoreData

enum DataProviderUpdate {
    case insert(IndexPath)
    case update(IndexPath, NSManagedObject)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}

import CoreData

enum DataProviderUpdate {
    case insert(IndexPath)
    case update(IndexPath, ManagedObject)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}

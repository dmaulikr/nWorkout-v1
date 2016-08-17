import Foundation

protocol DataProvider: class {
    associatedtype Object
    func object(at: IndexPath) -> Object
    func index(of object: Object) -> IndexPath
    func numberOfItems(inSection section: Int) -> Int
    func numberOfSections() -> Int
}

extension DataProvider {
    func index(of object: Object) -> IndexPath {
        assertionFailure("Optional, you must implement this.")
        return IndexPath()
    }
}

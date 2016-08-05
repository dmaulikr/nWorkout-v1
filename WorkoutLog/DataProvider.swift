import Foundation

protocol DataProvider: class {
    associatedtype Object
    func object(at: IndexPath) -> Object
    func numberOfItems(inSection section: Int) -> Int
    
}

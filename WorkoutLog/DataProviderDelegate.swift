import Foundation
import CoreData

protocol DataProviderDelegate: class {
    associatedtype Object: NSManagedObject
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

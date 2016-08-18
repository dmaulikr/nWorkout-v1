import Foundation
import CoreData

protocol DataProviderDelegate: class {
    func dataProviderDidUpdate(updates: [DataProviderUpdate]?)
}

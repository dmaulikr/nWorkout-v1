import CoreData
import UIKit

protocol DataProviderDelegate: class {
     func dataProviderDidUpdate(updates: [DataProviderUpdate]?)
}

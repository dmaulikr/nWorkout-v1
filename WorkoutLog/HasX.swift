import UIKit
import CoreData

protocol HasContext {}
extension HasContext {
    public var context: NSManagedObjectContext { return CoreData.shared.context }
}

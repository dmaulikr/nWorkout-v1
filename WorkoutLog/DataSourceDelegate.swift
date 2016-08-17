import CoreData
import UIKit

protocol DataSourceDelegate: class {
    associatedtype Object: NSManagedObject
    associatedtype Cell: UITableViewCell
    func cellIdentifier(for object: Object) -> String
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String
}

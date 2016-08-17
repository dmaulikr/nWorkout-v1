import CoreData
import UIKit

protocol DataSourceDelegate: class {
    associatedtype Object: NSManagedObject
    associatedtype Cell: UITableViewCell
    func cellIdentifier(for object: Object) -> String
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String
    
    func canEditRow(at: IndexPath) -> Bool
    func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath)
}

extension DataSourceDelegate {
    func canEditRow(at: IndexPath) -> Bool { return false }
    func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) { }
}

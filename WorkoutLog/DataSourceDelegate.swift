import CoreData
import UIKit

protocol DataSourceDelegate: class {
    associatedtype Object: NSManagedObject
    associatedtype Cell: UITableViewCell
    func cellIdentifier(for object: Object) -> String
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String

    func numberOfSections() -> Int?
    func numberOfRows(inSection section: Int) -> Int?
    func cell(forRowAt indexPath: IndexPath, identifier: String) -> UITableViewCell?
    func canEditRow(at indexPath: IndexPath) -> Bool
    func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath)
    
}


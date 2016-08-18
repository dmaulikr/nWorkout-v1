import UIKit
import CoreData

//private var observer: ManagedObjectObserver?
//{
//didSet {
//    observer = ManagedObjectObserver(object: source) { [unowned self] type in
//        guard type == .delete else { return }
//        let _ = self.navigationController?.popViewController(animated: true)
//    }
//}
//}




class TVCWithTableViewInCells<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithTVDS<Source,Type,Cell> where Type: ManagedObjectType, Source: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider {

    func stringForButton() -> String {
        assertionFailure("Implement this")
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: stringForButton(), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    func observeNotification(named name: String) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: nil, queue: OperationQueue.main) { notification in
            let type = notification.object as! Type
            var indexPath = self.dataProvider.index(of: type)
            if indexPath.row > 1000000 {
                print("WTF THE ROW IS \(indexPath.row))")
                indexPath.row = 0
            }
            let cell = self.tableView.cellForRow(at: indexPath)!
            let change: CGFloat = notification.userInfo!["change"] as! String == "add" ? CGFloat(Lets.subTVCellSize) : -CGFloat(Lets.subTVCellSize)
            //TODO: This sould not be a number.
            self.tableView.beginUpdates()
            UIView.animate(withDuration: Lets.tableCellAdditionAnimationDuration) {
                cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height + change)
            }
            self.tableView.endUpdates()
            //            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addButtonTapped() {
        let nlvc = NewVC(type: Type.self, placeholder: Lets.newLiftPlaceholderText, barButtonItem: navigationItem.rightBarButtonItem!, callback: insertNewObject)
        present(nlvc, animated: true)
    }
    
    func insertNewObject(object: Type) {
        var newIndexPath: IndexPath?
        
        context.performAndWait {
            newIndexPath = self.dataProvider.insert(object: object)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
        guard let indexPath = newIndexPath else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let object = dataProvider.object(at: indexPath)
        let count = object.numberOfItems(inSection: 0)
        
        return CGFloat(Lets.heightBetweenTopOfCellAndTV + Double(count + 1) * Lets.subTVCellSize)
    }
    

    
    //DataSourceDelegate
    //Has to be here to be overrideable
    
    override func canEditRow(at: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.dataProvider.managedObjectContext?.performAndWait {
                let object = self.dataSource.dataProvider.object(at: indexPath)
                self.dataSource.dataProvider.managedObjectContext?.delete(object)
                do {
                    try self.dataSource.dataProvider.managedObjectContext!.save()
                } catch let error {
                    print(error)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
}

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

class TVCWithTableViewCellWithTableView<Source: DataProvider, Type: NSManagedObject, Cell: TableViewCellWithTableView>: TVCWithTVDS<Source,Type,Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider, Source: NSManagedObject {
    
    func stringForButton() -> String {
        assertionFailure("Implement this")
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: stringForButton(), style: .plain, target: self, action: #selector(addButtonTapped))
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
            dataProvider.managedObjectContext?.performAndWait {
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
    
    override func cell(forRowAt indexPath: IndexPath, identifier: String) -> Cell? {
        return Cell(delegateAndDataSource: self, indexPath: indexPath, subTableViewCellType: UITableViewCell.self)
    }
    
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        return num
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        tvcell.textLabel?.text = lift.description
        return tvcell
    }
}

extension TVCWithTableViewCellWithTableView: TableViewCellWithTableViewDataSource {

}

extension TVCWithTableViewCellWithTableView: TableViewCellWithTableViewDelegate {}
























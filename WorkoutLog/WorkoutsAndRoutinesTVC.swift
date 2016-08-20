import UIKit
import CoreData


class WorkoutsAndRoutinesTVC<Type: NSManagedObject, Cell: TableViewCellWithTableView>: CDTVCWithTVDS<Type, Cell> where Cell: ConfigurableCell, Type: ManagedObjectType, Cell.DataSource == Type, Type: DataProvider {
    
    
    // DataSourceDelegate
    override func canEditRow(at indexPath: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = dataSource.dataProvider.object(at: indexPath)
            object.managedObjectContext!.performAndWait {
                object.managedObjectContext!.delete(object)
            }
            do {
                try object.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
    }
    
    override func cell(forRowAt indexPath: IndexPath, identifier: String) -> Cell? {
        let anyDADS = AnyTVCWTVDADS(dads: self)
        return Cell(delegateAndDataSource: anyDADS, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        return num
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return innerCell
    }
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        fatalError()
    }
    func thing(innerCell: Int) { }
}

extension WorkoutsAndRoutinesTVC: TableViewCellWithTableViewDelegateAndDataSource { }

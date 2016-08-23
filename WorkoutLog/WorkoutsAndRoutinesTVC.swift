import UIKit
import CoreData


class WorkoutsAndRoutinesTVC<Type: ManagedObject, Cell: TableViewCellWithTableView>: TableViewController<FetchedResultsDataProvider<Type>, Type, Cell> where Cell: ConfigurableCell, Type: ManagedObjectType, Cell.DataSource == Type, Type: DataProvider {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete  else { fatalError("editingStyle == \(editingStyle)") }
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { _ in
            let object = self.dataProvider.object(at: indexPath)
            object.managedObjectContext!.performAndWait {
                object.managedObjectContext!.delete(object)
            }
            do {
                try object.managedObjectContext?.save()
            } catch {
                print(error: error)
            }
            self.tableView.deleteRows(at: [indexPath], with: .none)
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel){ _ in
            //
        })
        present(alert, animated: true)
        
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let outerCell = Cell(delegateAndDataSource: self, indexPath: indexPath)
        outerCell.tableView.isUserInteractionEnabled = false
        let object = dataProvider.object(at: indexPath)
        outerCell.configureForObject(object: object, at: indexPath)
        return outerCell
    }
    //UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    
    //TVCWTVDaDS
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        return num
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat { return Lets.subTVCellSize }
    func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? { return nil }
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) { cell.tableView.register(WRSetCell.self, forCellReuseIdentifier: "cell") }
    func thing(innerCell: Int) { }
}

extension WorkoutsAndRoutinesTVC: TableViewCellWithTableViewDelegateAndDataSource { }

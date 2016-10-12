import UIKit
import CoreData


class WorkoutsAndRoutinesTVC<Type: ManagedObject, Cell: TableViewCellWithTableView>: TableViewController<FetchedResultsDataProvider<Type>, Type, Cell> where Cell: ConfigurableCell, Type: ManagedObjectType, Cell.DataSource == Type, Type: DataProvider {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TableViewCellWithTableView
        cell.innerTableFooterView?.isUserInteractionEnabled = false
        
        return cell
    }
    
    //TVCWTVDaDS
    override func numberOfSections(in cell: TableViewCellWithTableView) -> Int { return 1 }
    override func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.object(at: cell.outerIndexPath).numberOfItems(inSection: section)
    }
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    override func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return super.cellClassForInnerTableView(for: cell)
    }
    override func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return super.reuseIdentifierForInnerTableView(for: cell)
    }
    override func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? { return nil }
}


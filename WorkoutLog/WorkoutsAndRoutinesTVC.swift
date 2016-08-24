import UIKit
import CoreData


class WorkoutsAndRoutinesTVC<Type: ManagedObject, Cell: TableViewCellWithTableView>: TableViewController<FetchedResultsDataProvider<Type>, Type, Cell> where Cell: ConfigurableCell, Type: ManagedObjectType, Cell.DataSource == Type, Type: DataProvider {
    
    // UITableViewDataSource
    
    //UITableViewDelegate

    
    //TVCWTVDaDS
    override func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        return num
    }
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    override func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat { return Lets.subTVCellSize }
    override func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? { return nil }
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) { cell.tableView.register(InnerTableViewCell.self, forCellReuseIdentifier: "cell") }
}


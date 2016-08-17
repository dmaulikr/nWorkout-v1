import UIKit
import CoreData

class CoreDataTVC<Type: NSManagedObject, Cell: UITableViewCell>: TVCWithContext where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
        
    internal typealias DataProv = FetchedResultsDataProvider<CoreDataTVC>
    internal var dataSource: TableViewDataSource<CoreDataTVC, DataProv, Cell>!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifierForRegistration(for: Cell.self))
        
        
        let request = Type.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider =  FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    //DataSourceDelegate
    //Has to be here to be overrideable
    func cellIdentifier(for object: Type) -> String {
        assertionFailure("You must override cellIdentifier(for object: Type")
        return ""
    }
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String {
        assertionFailure("You must override cellIdentifier(for object: Type")
        return ""
    }
    
    func canEditRow(at: IndexPath) -> Bool {
        return false
    }
    func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        //
    }
}

extension CoreDataTVC: DataSourceDelegate {}

extension CoreDataTVC: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Type>]?) {
        dataSource.processUpdates(updates: updates)
    }
}



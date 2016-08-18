import UIKit
import CoreData

class CoreDataTVC<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithTVDS<Source,Type,Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type {
    
    init() {
        let request = Type.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
            
    override func setupTableView() {
        super.setupTableView()
        tableView.estimatedRowHeight = 40
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifierForRegistration(for: Cell.self))
        
        
        let request = Type.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider =  FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
}

extension CoreDataTVC: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Type>]?) {
        dataSource.processUpdates(updates: updates)
    }
}



import UIKit
import CoreData

class TableViewController<Source: DataProvider, Type: ManagedObject, Cell: UITableViewCell>: UITableViewController where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Source.Object: ManagedObject {
    
    var context = CoreData.shared.context
    
    init(dataProvider: Source) {
        super.init(style: .plain)
        self.dataProvider = dataProvider
        tableView = OuterTableView(frame: tableView.frame, style: .plain)
    }
    
    init(request: NSFetchRequest<Type>) {
        super.init(style: .plain)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: nil) as! Source
        tableView = OuterTableView(frame: tableView.frame, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var dataProvider: Source!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
}

extension TableViewController: DataProviderDelegate {
    typealias Object = Workout
    func dataProviderDidUpdate(updates: [DataProviderUpdate]?) {
//        dataSource.processUpdates(updates: updates)
    }
}

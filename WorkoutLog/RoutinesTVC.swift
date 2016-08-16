import UIKit
import CoreData

class RoutinesTVC: UITableViewController {
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Private
    private typealias RoutineDataProv = FetchedResultsDataProvider<RoutinesTVC, Routine>
    internal var dataSource: RoutinesTVDataSource! //TableViewDataSource<RoutinesTVC, RoutineDataProv, RoutineCell>!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        let request = Routine.request
        request.returnsObjectsAsFaults = false
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = RoutinesTVDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rtvc = segue.destination as! RoutineTVC
        switch segue.identifier! {
        case "showRoutine":
            guard let routine = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            rtvc.routine = routine
        case "newRoutine":
            rtvc.routine = Routine(context: context)
            rtvc.routine.name = "New routine"
        default: fatalError("No segue identifier for \(segue.identifier)")
        }
    }
}

extension RoutinesTVC: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Routine>]?) {
        dataSource.processUpdates(updates: updates)
    }
}

extension RoutinesTVC: DataSourceDelegate {
    func cellIdentifier(for object: Routine) -> String {
        return "routineCell"
    }
}

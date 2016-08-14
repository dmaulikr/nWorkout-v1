import UIKit
import CoreData

class WorkoutsTVC: UITableViewController {
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Private

    private typealias DataProv = FetchedResultsDataProvider<WorkoutsTVC, Workout>
    private var dataSource: TableViewDataSource<WorkoutsTVC, DataProv, TableViewCell>!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        let request = Workout.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider =  FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let wtvc = segue.destination as! WorkoutTVC
        switch segue.identifier! {
        case "viewWorkout":
            guard let workout = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            wtvc.workout = workout
        case "newWorkout":
            context.performAndWait {
                let workout = Workout(context: self.context)
                workout.date = Date()
                wtvc.workout = workout
            }
            try! context.save()
        default: fatalError("No segue identifier for \(segue.identifier)")
        }
    }
}

extension WorkoutsTVC: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Workout>]?) {
        dataSource.processUpdates(updates: updates)
    }
}

extension WorkoutsTVC: DataSourceDelegate {
    func cellIdentifier(for object: Workout) -> String {
        return "workoutCell"
    }
}

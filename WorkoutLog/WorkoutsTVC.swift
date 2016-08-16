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

    private typealias WorkoutDataProv = FetchedResultsDataProvider<WorkoutsTVC, Workout>
    internal var dataSource: WorkoutsTVDataSource!//TableViewDataSource<WorkoutsTVC, WorkoutDataProv, WorkoutCell>!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        let request = Workout.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider =  FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = WorkoutsTVDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "viewWorkout":
            let wtvc = segue.destination as! WorkoutTVC
            guard let workout = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            wtvc.workout = workout
        case "newWorkout":
            break
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

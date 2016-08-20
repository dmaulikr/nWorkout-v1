import UIKit
import CoreData

extension Workout: DataProvider {
    func object(at indexPath: IndexPath) -> Lift {
        return lifts!.object(at: indexPath.row) as! Lift
    }
    func insert(object: Lift) -> IndexPath {
        guard let context = managedObjectContext else { assertionFailure("Why doesn't this exist"); return IndexPath() }
        context.performAndWait {
            let set = LSet(context: context)
            set.targetWeight = 225
            set.targetReps = 5
            object.addToSets(set)
            self.addToLifts(object)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        return IndexPath(row: lifts!.count - 1, section: 0)
    }
    func index(of object: Lift) -> IndexPath {
        print(object)
        print(lifts!.index(of: object))
        return IndexPath(row: lifts!.index(of: object), section: 0)
    }
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int) -> Int {
        return lifts!.count
    }
}

class WorkoutsTVC: WorkoutsAndRoutinesTVC<Workout, WorkoutCell> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Lets.newWorkoutBarButtonText, style: .plain, target: self, action: #selector(newWorkout))
    }
    func newWorkout() {
        let swtvc = SelectWorkoutTVC(style: .grouped)
        navigationController?.pushViewController(swtvc, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wtvc = WorkoutTVC(dataProvider: dataSource.selectedObject!)
        navigationController?.pushViewController(wtvc, animated: true)
    }
    
    // DataSourceDelegate
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        innerCell.textLabel?.text = lift.name
        return innerCell
    }
    
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        cell.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

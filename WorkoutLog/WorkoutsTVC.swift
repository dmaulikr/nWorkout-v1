import UIKit
import CoreData

class WorkoutsTVC: CoreDataTVC<Workout, WorkoutCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Workout", style: .plain, target: self, action: #selector(newWorkout))
    }
    
    func newWorkout() {
        let swtvc = SelectWorkoutTVC(style: .grouped)
        navigationController?.pushViewController(swtvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wtvc = WorkoutTVC()
        wtvc.source = dataSource.selectedObject
        navigationController?.pushViewController(wtvc, animated: true)
    }
    
    // DataSourceDelegate
    override func cellIdentifier(for object: Workout) -> String {
        return "workoutCell"
    }
    override func cellIdentifierForRegistration(for cell: WorkoutCell.Type) -> String {
        return "workoutCell"
    }
    
    override func canEditRow(at indexPath: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = dataSource.dataProvider.object(at: indexPath)
            object.managedObjectContext!.performAndWait {
                object.managedObjectContext!.delete(object)
            }
            do {
                try object.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
    }
}

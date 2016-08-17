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
        wtvc.workout = dataSource.selectedObject
        navigationController?.pushViewController(wtvc, animated: true)
    }
    
    
    
    
    
    
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
    
    
    // DataSourceDelegate
    override func cellIdentifier(for object: Workout) -> String {
        return "workoutCell"
    }
    override func cellIdentifierForRegistration(for cell: WorkoutCell.Type) -> String {
        return "workoutCell"
    }
}

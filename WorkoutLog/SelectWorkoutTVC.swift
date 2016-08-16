import UIKit
import CoreData

class SelectWorkoutTVC: UITableViewController {
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()

    var routines: [Routine] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        let wtvc = segue.destination as! WorkoutTVC
        context.performAndWait {
            let workout = Workout(context: self.context)
            workout.date = NSDate()
            wtvc.workout = workout
        }
        try! context.save()
    }

}

extension SelectWorkoutTVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return routines.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Blank workout"
        } else {
            cell.textLabel?.text = routines[indexPath.row].name
        }
        return cell
    }
}

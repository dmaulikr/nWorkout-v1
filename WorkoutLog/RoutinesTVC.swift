import UIKit
import CoreData

class RoutinesTVC: UITableViewController {
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    var routines = [Routine]() {
        didSet {
            expanded = Array<Bool>(repeating: false, count: routines.count)
        }
    }
    var expanded: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        expanded = Array<Bool>(repeating: false, count: routines.count)
    }
    @IBAction func addNewRoutineButtonTapped(_ sender: UIBarButtonItem) {
        routines.append(Routine())
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return routines.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expanded[section] {
            return routines[section].workoutsAndDays.count + 2
        } else {
            return 1
        }
    }
    
    func setUpHeaderCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineHeaderCell", for: indexPath) as! RoutineHeaderCell
        let routine = routines[indexPath.section]
        cell.routineNameTextField.text = routine.name
        return cell
    }
    
    func setUpAddNewWorkoutCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewWorkoutCell", for: indexPath)
        cell.textLabel?.text = "Add workout..."
        return cell
    }
    
    func setUpWorkoutCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        let workoutAndDay = routines[indexPath.section].workoutsAndDays[indexPath.row - 1]
        cell.textLabel?.text = "\(workoutAndDay.0) on \(workoutAndDay.1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return setUpHeaderCellFor(indexPath)
        } else if indexPath.row == routines[indexPath.section].workoutsAndDays.count + 1 {
            return setUpAddNewWorkoutCellFor(indexPath)
        } else {
            return setUpWorkoutCellFor(indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            expanded[indexPath.section] = !expanded[indexPath.section]
        } else if indexPath.row == routines[indexPath.section].workoutsAndDays.count + 1 {
            routines[indexPath.section].workoutsAndDays.append((Workout(context: context),.monday))
        }
        tableView.reloadData()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

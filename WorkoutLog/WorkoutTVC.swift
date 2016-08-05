import UIKit
import CoreData


class WorkoutTVC: UITableViewController {
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    private var observer: ManagedObjectObserver?
    var workout: Workout! {
        didSet {
            observer = ManagedObjectObserver(object: workout) { [unowned self] type in
                guard type == .delete else { return }
                let _ = self.navigationController?.popViewController(animated: true)
            }
            //updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    @IBAction func addLiftButtonTapped(_ sender: UIBarButtonItem) {
        let lift = Lift(context: context)
        lift.name = "Squat"
        let set1 = LSet(context: context)
        set1.targetReps = 5
        set1.weight = 225
        lift.sets = [set1]
        workout.addToLifts(lift)
        try! context.save()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return workout.lifts!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (workout.lifts?[section] as! Lift).expanded {
            return workout.lifts![section].sets!!.count + 2
        } else {
            return 1
        }
    }
    
    func setUpHeaderCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderCell
        let lift = workout.lifts![indexPath.section]
        cell.nameTextField.text = lift.name
        return cell
    }
    
    func setUpAddNewSetCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewRowCell", for: indexPath)
        cell.textLabel?.text = "Add set..."
        return cell
    }
    
    func setUpSetCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! SetCell
        let set = workout.lifts![indexPath.section].sets!![indexPath.row - 1]
        cell.weightTextField.text = "\(set.weight!)"
        cell.targetRepsTextField.text = "\(set.targetReps!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return setUpHeaderCellFor(indexPath)
        } else if indexPath.row == workout.lifts![indexPath.section].sets!!.count + 1 {
            return setUpAddNewSetCellFor(indexPath)
        } else {
            return setUpSetCellFor(indexPath)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            (workout.lifts![indexPath.section] as! Lift).expanded = !workout.lifts![indexPath.section].expanded
        } else if indexPath.row == workout.lifts![indexPath.section].sets!!.count + 1 {
            workout.lifts?[indexPath.section].addToSets(LSet(context: context))
            try! context.save()
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 || indexPath.row == workout.lifts![indexPath.section].sets!!.count + 1 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            workout.lifts![indexPath.section].removeFromSets(at: indexPath.row - 1)
            try! context.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            //
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let lift = workout.lifts![fromIndexPath.section] as! Lift
        let from = lift.sets![fromIndexPath.row - 1] as! LSet
        lift.removeFromSets(at: fromIndexPath.row - 1)
        lift.insertIntoSets(from, at: to.row - 1)
        try! context.save()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 || indexPath.row == workout.lifts![indexPath.section].sets!!.count + 1 {
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

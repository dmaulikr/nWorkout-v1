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
    
    var keyboardView: Keyboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false

        keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(forName: "setsDidChange" as Notification.Name, object: nil, queue: OperationQueue.main) { notification in
            let lift = notification.object as! Lift
            let index = self.workout.lifts!.index(of: lift)
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if navigationController!.viewControllers[1] is SelectWorkoutTVC {
            navigationController!.viewControllers.remove(at: 1)
        }
    }
    
    
    @IBAction func addLiftButtonTapped(_ sender: UIBarButtonItem) {
        let lift = Lift(context: context)
        lift.name = "Squat"
        let set1 = LSet(context: context)
        set1.targetReps = 5
        set1.targetWeight = 225
        lift.sets = [set1]
        workout.addToLifts(lift)
        try! context.save()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.lifts!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        cell.lift = workout.lifts![indexPath.row] as! Lift
        cell.nameLabel?.text = cell.lift.name!
        cell.tableView.reloadData()
        cell.keyboardView = keyboardView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lift = workout.lifts![indexPath.row] as! Lift
        let setCount = lift.sets!.count
        
        return CGFloat(82 + (setCount + 1) * 46)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}


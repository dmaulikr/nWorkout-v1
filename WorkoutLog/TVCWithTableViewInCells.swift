import UIKit
import CoreData


class TVCWithTableViewInCells<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithContext where Type: ManagedObjectType, Source: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type {
    
    private var observer: ManagedObjectObserver?
    
    init(source: Source) {
        self.source = source
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var source: Source {
        didSet {
            observer = ManagedObjectObserver(object: source) { [unowned self] type in
                guard type == .delete else { return }
                let _ = self.navigationController?.popViewController(animated: true)
            }
            //updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowseSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "setsDidChange"), object: nil, queue: OperationQueue.main) { notification in
            let type = notification.object as! Type
            let indexPath = self.source.index(of: type)
            let cell = self.tableView.cellForRow(at: indexPath)!
            let change: CGFloat = notification.userInfo!["change"] as! String == "add" ? 44 : -44
            //TODO: This sould not be a number.
            self.tableView.beginUpdates()
            UIView.animate(withDuration: 0.3) {
                cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height + change)
            }
            self.tableView.endUpdates()
            //            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if navigationController!.viewControllers[1] is SelectWorkoutTVC {
            navigationController!.viewControllers.remove(at: 1)
        }
    }
    
    
//    @IBAction func addLiftButtonTapped(_ sender: UIBarButtonItem) {
//        let lift = Lift(context: context)
//        lift.name = "Squat"
//        let set1 = LSet(context: context)
//        set1.targetReps = 5
//        set1.targetWeight = 225
//        lift.sets = [set1]
//        workout.addToLifts(lift)
//        try! context.save()
//        tableView.reloadData()
//    }
    
    internal var dataSource: TableViewDataSource<TVCWithTableViewInCells, Source, Cell>!
    
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
}


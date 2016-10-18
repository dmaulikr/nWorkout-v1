import UIKit
import CoreData

class RoutinesTVC: WorkoutsAndRoutinesTVC<Routine, RoutineCell>, UIPopoverPresentationControllerDelegate, RoutineCellDelegate {
    
    init() {
        let request = Routine.request
        request.fetchBatchSize = Lets.defaultBatchSize
        request.returnsObjectsAsFaults = false
        super.init(request: request)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newRoutine))
        navigationItem.rightBarButtonItem = editButtonItem
    }
    func newRoutine() {
        let nrtvc = NewVC(type: Routine.self, placeholder: "Insert new routine name", barButtonItem: navigationItem.leftBarButtonItem!) { object in
            
        }
        present(nrtvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let routineCell = cell as? RoutineCell {
            routineCell.routineCellDelegate = self
        }
        return cell
    }
    
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = dataProvider.object(at: indexPath)
        let wtvc = RoutineTVC(dataProvider: workout)
        navigationController?.pushViewController(wtvc, animated: true)
    }
    
    // TVCWTVDADS
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InnerTableViewCell
        let lift = dataProvider.object(at: cell.outerIndexPath).object(at: indexPath)
        innerCell.textLabel?.text = lift.name! + " x \(lift.sets!.count)"
        innerCell.isUserInteractionEnabled = false
        return innerCell
    }
    
    func routineCell(_ routineCell: RoutineCell, nameChangedTo name: String) {
        let object = dataProvider.object(at: routineCell.outerIndexPath)
        object.managedObjectContext?.perform {
            object.name = name
            try! object.managedObjectContext?.save()
        }
    }
    func userInputEmptyName() {
        let alert = UIAlertController(title: "Name Missing", message: "Routines require a valid name.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    
}

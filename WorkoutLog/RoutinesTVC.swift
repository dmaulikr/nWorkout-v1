import UIKit
import CoreData

class RoutinesTVC: WorkoutsAndRoutinesTVC<Routine, RoutineCell>, UIPopoverPresentationControllerDelegate {
    
    init() {
        let request = Routine.request
        request.fetchBatchSize = Lets.defaultBatchSize
        request.returnsObjectsAsFaults = false
        super.init(request: request)
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
}

import UIKit
import CoreData


class RoutinesTVC: WorkoutsAndRoutinesTVC<Routine, RoutineCell>, UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Routine", style: .plain, target: self, action: #selector(newRoutine))
        navigationItem.title = "Workouts"
    }
    func newRoutine() {
        let nrtvc = NewVC(type: Routine.self, placeholder: "Insert new routine name", barButtonItem: navigationItem.rightBarButtonItem!) { object in }
        present(nrtvc, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rtvc = RoutineTVC(dataProvider: dataSource.selectedObject!)
        navigationController?.pushViewController(rtvc, animated: true)
    }
    
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WRSetCell
        let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        innerCell.textLabel?.text = lift.name
        return innerCell
    }
}

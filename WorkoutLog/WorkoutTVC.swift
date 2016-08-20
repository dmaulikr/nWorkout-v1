import UIKit
import CoreData

class WorkoutTVC: WorkoutAndRoutineTVC<Workout,Lift,LiftCell> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController!.viewControllers[1] is SelectWorkoutTVC {
            navigationController!.viewControllers.remove(at: 1)
        }
    }
    
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetCell
        if indexPath.section == 0 {
            innerCell.textLabel?.text = "Add set..."
            innerCell.textFields.forEach { $0.isHidden = false }
            innerCell.statusButton.isHidden = false
        } else {
            let set = dataProvider.object(at: cell.indexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
        }
        return innerCell
    }
    
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        cell.tableView.register(SetCell.self, forCellReuseIdentifier: "cell")
    }
}

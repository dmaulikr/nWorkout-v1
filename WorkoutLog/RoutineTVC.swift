import UIKit
import CoreData

class RoutineTVC: WorkoutAndRoutineTVC<Routine, RoutineLift, RoutineLiftCell> {

    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoutineSetCell
        if indexPath.section == 1 {
            innerCell.textLabel?.text = Lets.addSetText
            innerCell.textFields.forEach { $0.isHidden = true }
        } else {
            let set = dataProvider.object(at: cell.indexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
        }
        return innerCell
    }
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        cell.tableView.register(RoutineSetCell.self, forCellReuseIdentifier: "cell")
    }

}



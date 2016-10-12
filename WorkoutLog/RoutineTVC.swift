import UIKit
import CoreData

class RoutineTVC: WorkoutAndRoutineTVC<Routine, RoutineLift, RoutineLiftCell> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = dataProvider.name!
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 0 {
            (cell as! RoutineLiftCell).liftCellDelegate = self
        }
        return cell
    }
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let tableViewCell = cell.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            tableViewCell.textLabel?.text = Lets.addSetText
            return tableViewCell
        } else {
            let innerCell = cell.dequeueReusableCell(withIdentifier: "routineSetCell", for: indexPath) as! RoutineSetCell
            let set = dataProvider.object(at: cell.outerIndexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
            return innerCell
        }
    }
    override func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return ["routineSetCell", "cell"]
    }
    override func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return [RoutineSetCell.self, InnerTableViewCell.self]
    }

}



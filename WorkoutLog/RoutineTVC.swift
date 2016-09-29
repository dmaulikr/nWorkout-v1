import UIKit
import CoreData

class RoutineTVC: WorkoutAndRoutineTVC<Routine, RoutineLift, RoutineLiftCell> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = dataProvider.name!
    }
    
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let tableViewCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            tableViewCell.textLabel?.text = Lets.addSetText
            return tableViewCell
        } else {
            let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "routineSetCell", for: indexPath) as! RoutineSetCell
            let set = dataProvider.object(at: cell.indexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
            return innerCell
        }
    }
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        cell.tableView.register(RoutineSetCell.self, forCellReuseIdentifier: "routineSetCell")
        cell.tableView.register(InnerTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}



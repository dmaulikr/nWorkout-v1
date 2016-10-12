import UIKit
import CoreData

class WorkoutTVC: WorkoutAndRoutineTVC<Workout,WorkoutLift,WorkoutLiftCell> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, H:mm a"
        navigationItem.title = dateFormatter.string(from: dataProvider.date! as Date)
    }
    
    func hideButtonPushed() {
        navigationController?.presentingViewController?.dismiss(animated: true) { }
    }
    
    //UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 0 {
            (cell as! WorkoutLiftCell).liftCellDelegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            let dummyTabBarItem = (UIApplication.shared.delegate as! AppDelegate).appCoordinator.dummy.tabBarItem
            dummyTabBarItem?.title = "new"
            dummyTabBarItem?.image = #imageLiteral(resourceName: "newWorkout")
            context.perform {
                self.dataProvider.complete = true
                do {
                    try self.context.save()
                } catch {
                    print(error: error)
                }
            }
            
            navigationController?.presentingViewController?.dismiss(animated: true) {
                self.navigationController?.viewControllers.removeLast()
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    // TVWTVCDADS
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let tableViewCell = cell.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            tableViewCell.textLabel?.text = Lets.addSetText
            return tableViewCell
        } else {
            let innerCell = cell.dequeueReusableCell(withIdentifier: "workoutSetCell", for: indexPath) as! WorkoutSetCell
            innerCell.delegate = cell as! WorkoutLiftCell
            let set = dataProvider.object(at: cell.outerIndexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
            return innerCell
        }
    }
    
    override func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return ["workoutSetCell", "cell"]
    }
    override func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return [WorkoutSetCell.self, InnerTableViewCell.self]
    }
    
}


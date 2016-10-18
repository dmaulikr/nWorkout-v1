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
    
    func closeActiveWorkout() {
        let dummyTabBarItem = (UIApplication.shared.delegate as! AppDelegate).appCoordinator.dummy.tabBarItem
        dummyTabBarItem?.title = "new"
        dummyTabBarItem?.image = #imageLiteral(resourceName: "newWorkout")
        navigationController?.presentingViewController?.dismiss(animated: true) {
            self.navigationController?.viewControllers.removeLast()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                
                let alert = UIAlertController(title: "Finish Workout?", message: "Are you sure you want to finish this workout?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let finish = UIAlertAction(title: "Finish", style: .default) { _ in
                    self.context.perform {
                        self.dataProvider.complete = true
                        self.dataProvider.finishDate = Date()
                        do {
                            try self.context.save()
                        } catch {
                            print(error: error)
                        }
                    }
                    self.closeActiveWorkout()
                }
                alert.addAction(cancel)
                alert.addAction(finish)
                present(alert, animated: true, completion: nil)
            } else if indexPath.row == 2{
                let alert = UIAlertController(title: "Cancel Workout?", message: "Are you sure you want to cancel this workout?", preferredStyle: .alert)
                let no = UIAlertAction(title: "Continue Workout", style: .cancel, handler: nil)
                let cancelWorkout = UIAlertAction(title: "Cancel Workout", style: .destructive) { _ in
                    self.closeActiveWorkout()
                }
                alert.addAction(no)
                alert.addAction(cancelWorkout)
                present(alert, animated: true, completion: nil)
            } else {
                super.tableView(tableView, didSelectRowAt: indexPath)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // TVWTVCDADS
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let tableViewCell = cell.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            tableViewCell.textLabel?.text = Lets.addSetText
            return tableViewCell
        } else {
            let innerCell = cell.dequeueReusableCell(withIdentifier: "workoutSetCell", for: indexPath) as! WorkoutSetCell
            innerCell.selectionStyle = .none
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


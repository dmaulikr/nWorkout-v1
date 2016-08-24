import UIKit
import CoreData

class WorkoutTVC: WorkoutAndRoutineTVC<Workout,WorkoutLift,WorkoutLiftCell> {
    
    func hideButtonPushed() {
        navigationController?.presentingViewController?.dismiss(animated: true) {
            
        }
    }
    
    //UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        let newWorkoutNav = (UIApplication.shared.delegate as! AppDelegate).appCoordinator.newWorkoutNav
        if navigationController == newWorkoutNav {
            return 2
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.numberOfItems(inSection: section)
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return super.tableView(tableView, cellForRowAt: indexPath)
        } else {
            let cell = InnerTableViewCell()
            cell.textLabel?.text = "Finish Workout"
            return cell
        }
    }
    
    // TVWTVCDADS
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkoutSetCell
        if indexPath.section == 1 {
            innerCell.textLabel?.text = Lets.addSetText
            innerCell.textFields.forEach { $0.isHidden = true }
            innerCell.statusButton.isHidden = true
        } else {
            let set = dataProvider.object(at: cell.indexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
        }
        return innerCell
    }
    
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        cell.tableView.register(WorkoutSetCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return Lets.subTVCellSize
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return super.tableView(tableView, willSelectRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
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
        }
        else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}

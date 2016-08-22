import UIKit
import CoreData

class WorkoutTVC: WorkoutAndRoutineTVC<Workout,Lift,LiftCell> {
    
    func hideButtonPushed() {
        presentingViewController?.dismiss(animated: true) {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController!.viewControllers[0] is SelectWorkoutTVC {
            navigationController!.viewControllers.remove(at: 0)
        }
    }
    override func numberOfSections() -> Int? {
        return 2
    }
    override func numberOfRows(inSection section: Int) -> Int? {
        if section == 0 {
            return super.numberOfRows(inSection: section)
        } else {
            return 1
        }
    }
    override func cell(forRowAt indexPath: IndexPath, identifier: String) -> UITableViewCell? {
        if indexPath.section == 0 {
            return super.cell(forRowAt: indexPath, identifier: identifier)
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Finish Workout"
            return cell
        }
    }
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetCell
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
        cell.tableView.register(SetCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return Lets.subTVCellSize
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

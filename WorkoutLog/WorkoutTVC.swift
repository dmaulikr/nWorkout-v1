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
                        CoreData.shared.save()
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
                    let context = self.dataProvider.managedObjectContext!
                    context.perform {
                        context.delete(self.dataProvider)
                        CoreData.shared.save()
                    }
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
        let c = super.cell(cell, cellForRowAt: indexPath)
        if let innerCell = c as? WorkoutSetCell {
            innerCell.noteButton.actionClosure = { [unowned self] button in
                let object = self.dataProvider.object(at: cell.outerIndexPath)
                let noteVC = NoteVC(object: object, placeholder: "", button: button, callback: nil)
                self.present(noteVC, animated: true, completion: nil)
            }
        }
        return c
    }
    
    override func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return ["setCell", "cell"]
    }
    override func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return [WorkoutSetCell.self, UITableViewCell.self]
    }
}


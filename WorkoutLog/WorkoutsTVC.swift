import UIKit
import CoreData


class WorkoutsTVC: CDTVCWithTVDS<Workout, WorkoutCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Lets.newWorkoutBarButtonText, style: .plain, target: self, action: #selector(newWorkout))
    }
    
    func newWorkout() {
        let swtvc = SelectWorkoutTVC(style: .grouped)
        navigationController?.pushViewController(swtvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wtvc = WorkoutTVC(dataProvider: dataSource.selectedObject!)
        
        navigationController?.pushViewController(wtvc, animated: true)
    }
    
    // DataSourceDelegate
    override func cellIdentifier(for object: Workout) -> String {
        return "workoutCell"
    }
    override func cellIdentifierForRegistration(for cell: WorkoutCell.Type) -> String {
        return "workoutCell"
    }
    
    override func canEditRow(at indexPath: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = dataSource.dataProvider.object(at: indexPath)
            object.managedObjectContext!.performAndWait {
                object.managedObjectContext!.delete(object)
            }
            do {
                try object.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
    }    
    
    override func cell(forRowAt indexPath: IndexPath, identifier: String) -> WorkoutCell? {
        return WorkoutCell(delegateAndDataSource: self, indexPath: indexPath)
    }
 
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
}


extension WorkoutsTVC: TableViewCellWithTableViewDataSource {
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        return num
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        tvcell.textLabel?.text = lift.name
        return tvcell
    }
}
extension WorkoutsTVC: TableViewCellWithTableViewDelegate {
    
}

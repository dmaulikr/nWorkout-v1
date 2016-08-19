import UIKit
import CoreData

extension Workout: ManagedObjectType {
    public static var entityName: String {
        return "Workout"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}

class WorkoutsTVC: CDTVCWithTVDS<Workout, WorkoutCell>, TableViewCellWithTableViewDataSourceAndDelegate {
    
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
        return WorkoutCell(delegateAndDataSource: self, indexPath: indexPath, subTableViewCellType: UITableViewCell.self)
    }
 
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    
    func rowAt(outerIndexPath: IndexPath, numberOfRowsInSection section: Int) -> Int {
        return 0
        //eeelet num = dataProvider.object(at: outerIndexPath).numberOfItems(inSection: section)
        //cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        //return num
    }
    func rowAt(outerIndexPath: IndexPath, cellForRowAtInner innerIndexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        //let tvcell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        //tvcell.textLabel?.text = lift.name
        //return tvcell
    }
}

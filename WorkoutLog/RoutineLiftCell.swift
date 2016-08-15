import UIKit
import CoreData

extension RoutineLift: DataProvider {
    typealias Object = RoutineSet
    func object(at: IndexPath) -> RoutineSet {
        return sets!.object(at: at.row) as! RoutineSet
    }
    func numberOfItems(inSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        if let sets = sets {
            return sets.count
        } else {
            return 0
        }
    }
    func numberOfSections() -> Int {
        return 2
    }
}

class RoutineLiftCell: UITableViewCell {
    var lift: RoutineLift! {
        didSet {
            dataSource = RoutineLiftCellTVDataSource(tableView: tableView, dataProvider: lift, delegate: self)
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isScrollEnabled = false
            tableView.delegate = self
            tableView.allowsMultipleSelectionDuringEditing = false
        }
    }
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    private var dataSource: RoutineLiftCellTVDataSource!
}

extension RoutineLiftCell: DataSourceDelegate {
    typealias Object = RoutineSet
    func cellIdentifier(for object: RoutineSet) -> String {
        return "routineSetCell"
    }
}


extension RoutineLiftCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        context.performAndWait {
            let newSet = RoutineSet(context: self.context)
            newSet.weight = (self.lift.sets?.lastObject as? RoutineSet)?.weight ?? 0
            newSet.reps = (self.lift.sets?.lastObject as? RoutineSet)?.reps ?? 0
            
            self.lift.addToSets(newSet)
            try! self.context.save()
        }
        let path = IndexPath(row: lift.sets!.count - 1, section: 0)
        tableView.insertRows(at: [path], with: .automatic)
        let notification = Notification(name: "setsDidChange" as Notification.Name, object: self.lift, userInfo: ["change":"add"])
        NotificationCenter.default.post(notification)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
}


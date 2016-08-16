import UIKit
import CoreData

extension Lift: DataProvider {
    typealias Object = LSet
    func object(at: IndexPath) -> LSet {
        return sets!.object(at: at.row) as! LSet
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

class LiftCell: UITableViewCell {
    var lift: Lift! {
        didSet {
            dataSource = LiftCellTVDataSource(tableView: tableView, dataProvider: lift, delegate: self)
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
    
    private var dataSource: LiftCellTVDataSource!
}

extension LiftCell: DataSourceDelegate {
    typealias Object = LSet
    func cellIdentifier(for object: LSet) -> String {
        return "setCell"
    }
}


extension LiftCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        context.performAndWait {
            let newSet = LSet(context: self.context)
            newSet.targetWeight = (self.lift.sets?.lastObject as? LSet)?.targetWeight ?? 0
            newSet.targetReps = (self.lift.sets?.lastObject as? LSet)?.targetReps ?? 0
            
            self.lift.addToSets(newSet)
            try! self.context.save()
        }
        let path = IndexPath(row: lift.sets!.count - 1, section: 0)
        tableView.insertRows(at: [path], with: .automatic)
        let notification = Notification(name: Notification.Name(rawValue:"setsDidChange"), object: self.lift, userInfo: ["change":"add"])
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


import UIKit
import CoreData

extension Lift: DataProvider {

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

class LiftCell: CellWithTableView<LSet, SetCell, Lift> {
    var nameLabel: UILabel!
    override var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    
    override func cellIdentifier(for object: LSet) -> String {
        return "setCell"
    }
    override func cellIdentifierForRegistration(for cell: SetCell.Type) -> String {
        return "setCell"
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        context.performAndWait {
            let newSet = LSet(context: self.context)
            newSet.targetWeight = (self.source.sets?.lastObject as? LSet)?.targetWeight ?? 0
            newSet.targetReps = (self.source.sets?.lastObject as? LSet)?.targetReps ?? 0
            
            self.source.addToSets(newSet)
            try! self.context.save()
        }
        let path = IndexPath(row: source.sets!.count - 1, section: 0)
        tableView.insertRows(at: [path], with: .automatic)
        let notification = Notification(name: Notification.Name(rawValue:"setsDidChange"), object: source, userInfo: ["change":"add"])
        NotificationCenter.default.post(notification)
    }
    
    @objc(tableView:willSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
}

extension LiftCell: UITableViewDelegate { /*can't implement in extension with generic class*/ }

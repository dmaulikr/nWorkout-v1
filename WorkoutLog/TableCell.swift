import UIKit
import CoreData

class TableCell: UITableViewCell {
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.isScrollEnabled = false
        }
    }
    var lift: Lift!
    
}

extension TableCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        context.performAndWait {
            let newSet = LSet(context: self.context)
            newSet.weight = 225
            newSet.targetReps = 5
            self.lift.addToSets(newSet)
            try! self.context.save()
        }
        let path = IndexPath(row: indexPath.row, section: indexPath.section)
//        tableView.insertRows(at: [path], with: .none)
        let notification = Notification(name: "setsDidChange" as Notification.Name, object: self.lift, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == lift.sets!.count {
            return indexPath
        } else {
            return nil
        }
    }
}

extension TableCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == lift!.sets!.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSetCell", for: indexPath)
            cell.textLabel?.text = "Add set..."
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as! SetCell
            cell.set = (lift.sets![indexPath.row] as! LSet)
            cell.targetRepsTextField.text = "\(cell.set.targetReps)"
            cell.targetWeightTextField.text = "\(cell.set.weight)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sets = lift?.sets {
            return sets.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == lift.sets!.count {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lift.managedObjectContext?.performAndWait {
                let set = self.lift.sets![indexPath.row] as! LSet
                self.lift.removeFromSets(set)
                self.context.delete(set)
                do {
                    try self.lift.managedObjectContext!.save()
                } catch let error {
                    print(error)
                }
            }
//            self.tableView.deleteRows(at: [indexPath], with: .none)
            let notification = Notification(name: "setsDidChange" as Notification.Name, object: self.lift, userInfo: nil)
            NotificationCenter.default.post(notification)
        }
    }
}

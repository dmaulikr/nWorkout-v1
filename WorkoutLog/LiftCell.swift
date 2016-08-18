import UIKit
import CoreData

extension Lift: DataProvider {
    
    func object(at indexPath: IndexPath) -> LSet {
        guard let sets = sets else { fatalError() }
        let lset = sets.object(at: indexPath.row)
        print(lset)
        return sets.object(at: indexPath.row) as! LSet
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

class LiftCell: CellWithTableView<Lift, LSet, SetCell> {
    
    var nameLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        let nameFrame = CGRect(x: 0, y: 0, width: Lets.liftCellNameLabelWidth, height: Lets.liftCellNameLabelHeight)
        nameLabel = UILabel(frame: nameFrame)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        
        
        //let margins = contentView.layoutMarginsGuide
        //tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        //tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        //tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        tableView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let frame = tableView.frame
        let height = frame.height
        let width = frame.width
        let x = frame.origin.x
        let y = frame.origin.y
        tableView.frame = CGRect(x: x, y: y, width: width, height: height + 45)
        
        tableView.insertRows(at: [path], with: .automatic)
        let notification = Notification(name: Notification.Name(rawValue:"setChanged"), object: source, userInfo: ["change":"add"])
        NotificationCenter.default.post(notification)
    }
    
    @objc(tableView:willSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    override func canEditRow(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        
        if editingStyle == .delete {
            dataSource.dataProvider.managedObjectContext?.performAndWait {
                let set = self.dataSource.dataProvider.sets![indexPath.row] as! LSet
                self.dataSource.dataProvider.managedObjectContext?.delete(set)
                do {
                    try self.dataSource.dataProvider.managedObjectContext!.save()
                } catch let error {
                    print(error)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .none)
            let frame = tableView.frame
            let height = frame.height
            let width = frame.width
            let x = frame.origin.x
            let y = frame.origin.y
            tableView.frame = CGRect(x: x, y: y, width: width, height: height -     45)
            let notification = Notification(name: Notification.Name(rawValue:"setChanged"), object: source, userInfo: ["change":"delete"])
            NotificationCenter.default.post(notification)
        }
    }

}

extension LiftCell: UITableViewDelegate { /*can't implement in extension with generic class*/ }

extension LiftCell: ConfigurableCell {
    func configureForObject(object: Lift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        source = object
    }
}

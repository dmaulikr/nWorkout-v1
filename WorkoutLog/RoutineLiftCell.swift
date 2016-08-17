import UIKit
import CoreData

extension RoutineLift: DataProvider {

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

class RoutineLiftCell: CellWithTableView<RoutineLift, RoutineSet, RoutineSetCell> {
    var nameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        let nameFrame = CGRect(x: 0, y: 0, width: 120, height: 40)
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

    override func cellIdentifier(for object: RoutineSet) -> String {
        return "routineSetCell"
    }
    override func cellIdentifierForRegistration(for cell: RoutineSetCell.Type) -> String {
        return "routineSetCell"
    }

    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        context.performAndWait {
            let newSet = RoutineSet(context: self.context)
            newSet.weight = (self.source.sets?.lastObject as? RoutineSet)?.weight ?? 0
            newSet.reps = (self.source.sets?.lastObject as? RoutineSet)?.reps ?? 0
            
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

extension RoutineLiftCell: UITableViewDelegate { }

extension RoutineLiftCell: ConfigurableCell {
    func configureForObject(object: RoutineLift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        source = object
    }
}

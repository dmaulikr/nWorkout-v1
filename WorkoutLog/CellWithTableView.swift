import UIKit
import CoreData

class CellWithTableView<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: UITableViewCell where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type {
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        tableView = UITableView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tableView)
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifierForRegistration(for: Cell.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
    var source: Source! {
        didSet {
            dataSource = TableViewDataSource(tableView: tableView, dataProvider: source, delegate: self)
            tableView.reloadData()
        }
    }
    var tableView: UITableView {
        didSet {
            tableView.isScrollEnabled = false
            tableView.allowsMultipleSelectionDuringEditing = false
        }
    }

    internal var dataSource: TableViewDataSource<CellWithTableView, Source, Cell>!
    
    
    //DataSourceDelegate
    //Has to be here to be overrideable
    func cellIdentifier(for object: Type) -> String {
        assertionFailure("You must override cellIdentifier(for object: Type")
        return ""
    }
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String {
        assertionFailure("You must override cellIdentifier(for object: Type")
        return ""
    }
}

extension CellWithTableView: DataSourceDelegate { /*implementation is in main class as you can't override functions declared in extensions */}



//extension CellWithTableView: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        
//        context.performAndWait {
//            let newSet = LSet(context: self.context)
//            newSet.targetWeight = (self.lift.sets?.lastObject as? LSet)?.targetWeight ?? 0
//            newSet.targetReps = (self.lift.sets?.lastObject as? LSet)?.targetReps ?? 0
//            
//            self.lift.addToSets(newSet)
//            try! self.context.save()
//        }
//        let path = IndexPath(row: lift.sets!.count - 1, section: 0)
//        tableView.insertRows(at: [path], with: .automatic)
//        let notification = Notification(name: Notification.Name(rawValue:"setsDidChange"), object: self.lift, userInfo: ["change":"add"])
//        NotificationCenter.default.post(notification)
//    }
//    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if indexPath.section == 1 {
//            return indexPath
//        } else {
//            return nil
//        }
//    }
//}


import UIKit
import CoreData


class TVCWithTableViewInCells<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithContext where Type: ManagedObjectType, Source: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider {
    
    private var observer: ManagedObjectObserver?

    var source: Source! {
        didSet {
            observer = ManagedObjectObserver(object: source) { [unowned self] type in
                guard type == .delete else { return }
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func stringForButton() -> String {
        assertionFailure("Implement this")
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: stringForButton(), style: .plain, target: self, action: #selector(addButtonTapped))        
    }
    
    private func setUpTableView() {
        tableView.allowsSelection = false
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifierForRegistration(for: Cell.self))
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: source, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "subTVCellDidChange"), object: nil, queue: OperationQueue.main) { notification in
            let type = notification.object as! Type
            let indexPath = self.source.index(of: type)
            let cell = self.tableView.cellForRow(at: indexPath)!
            let change: CGFloat = notification.userInfo!["change"] as! String == "add" ? 44 : -44
            //TODO: This sould not be a number.
            self.tableView.beginUpdates()
            UIView.animate(withDuration: 0.3) {
                cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height + change)
            }
            self.tableView.endUpdates()
            //            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func addButtonTapped() {
        var newIndexPath: IndexPath?
        context.performAndWait {
            newIndexPath = self.source.insert(object: Type(context: self.context))
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
        guard let indexPath = newIndexPath else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    internal var dataSource: TableViewDataSource<TVCWithTableViewInCells, Source, Cell>!
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let object = source.object(at: indexPath)
        let count = object.numberOfItems(inSection: 0)
        
        return CGFloat(82 + (count + 1) * 46)
    }
    
    
    //DataSourceDelegate
    //Has to be here to be overrideable
    func cellIdentifier(for object: Type) -> String {
        assertionFailure("Implement")
        return ""
    }
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String {
        assertionFailure("Implement")
        return ""
    }
}

extension TVCWithTableViewInCells: DataSourceDelegate {}

import UIKit
import CoreData

class TVCWithTVDS<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithContext where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type {
    
    init(dataProvider: Source) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }


    var dataSource: TableViewDataSource<TVCWithTVDS, Source, Cell>!
    var dataProvider: Source!
    
    internal func setupTableView() {
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifierForRegistration(for: Cell.self))
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    //DataSourceDelegate
    //Has to be here to be overrideable
    func cellIdentifier(for object: Type) -> String {
        return "cell"
    }
    func cellIdentifierForRegistration(for cell: Cell.Type) -> String {
        return "cell"
    }
    func canEditRow(at: IndexPath) -> Bool {
        print("Implement \(#function)")
        return false
    }
    func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        print("Implement \(#function)")
    }
    func cell(forRowAt indexPath: IndexPath, identifier: String) -> Cell? {
        return nil
    }
}

extension TVCWithTVDS: DataSourceDelegate {}


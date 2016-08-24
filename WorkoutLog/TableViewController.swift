import UIKit
import CoreData

class TableViewController<Source: DataProvider, Type: ManagedObject, Cell: TableViewCellWithTableView>: UITableViewController where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Source.Object: ManagedObject, Source.Object: DataProvider {
    
    var context = CoreData.shared.context
    
    init(dataProvider: Source) {
        super.init(style: .plain)
        self.dataProvider = dataProvider
        tableView = OuterTableView(frame: tableView.frame, style: .plain)
    }
    
    init(request: NSFetchRequest<Type>) {
        super.init(style: .plain)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: nil) as! Source
        tableView = OuterTableView(frame: tableView.frame, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var dataProvider: Source!
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError("Editing style == \(editingStyle)") }
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { _ in
            let object = self.dataProvider.object(at: indexPath)
            object.managedObjectContext?.performAndWait {
                object.managedObjectContext?.delete(object)
                do {
                    try self.context.save()
                } catch let error {
                    print(error: error)
                }
            }
            self.tableView.deleteRows(at: [indexPath], with: .none)
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel){ _ in
            self.tableView.endEditing(true)
        })
        present(alert, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let outerCell = Cell(delegateAndDataSource: self, indexPath: indexPath)
        let object = dataProvider.object(at: indexPath)
        outerCell.configureForObject(object: object, at: indexPath)
        return outerCell
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    
    //TVCWTVDaDS
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 1
    }
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        cell.heightConstraint.constant = CGFloat(num) * CGFloat(Lets.subTVCellSize)
        return num
    }
    
    func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) {
        fatalError()
    }
    func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fatalError()
    }
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat { return Lets.subTVCellSize }
    func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? { return nil }
    
    //Dummy since Swift can't find Subclass implementation without something to override.
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) { cell.tableView.register(InnerTableViewCell.self, forCellReuseIdentifier: "cell") }
}

extension TableViewController: TableViewCellWithTableViewDelegateAndDataSource {}

extension TableViewController: DataProviderDelegate {
    typealias Object = Workout
    func dataProviderDidUpdate(updates: [DataProviderUpdate]?) {
//        dataSource.processUpdates(updates: updates)
    }
}

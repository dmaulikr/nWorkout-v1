import UIKit
import CoreData

class TableViewController<Source: DataProvider, Type: ManagedObject, Cell: TableViewCellWithTableView>: UITableViewController, HasContext, TableViewCellWithTableViewDataSource, TableViewCellWithTableViewDelegate, DataProviderDelegate where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Source.Object: ManagedObject, Source.Object: DataProvider {
    
    override func loadView() {
        view = OuterTableView()
        print(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    init(dataProvider: Source) {
        super.init(style: .plain)
        self.dataProvider = dataProvider
    }
    init(request: NSFetchRequest<Type>) {
        super.init(style: .plain)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self) as! Source
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            if self.dataProvider is ManagedObject {
                self.tableView.deleteRows(at: [indexPath], with: .none)
            }
//            tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
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
        let outerCell = Cell(reuseIdentifier: "cell")
        outerCell.outerIndexPath = indexPath
        outerCell.dataSource = self
        outerCell.delegate = self
        
        let object = dataProvider.object(at: indexPath)
        outerCell.configureForObject(object: object, at: indexPath)
        
        return outerCell
    }
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return indexPath }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    func setOuterIndexPaths() {
        for cell in tableView.visibleCells {
            if let tvcwtv = cell as? TableViewCellWithTableView {
                tvcwtv.outerIndexPath = tableView.indexPath(for: cell)
            }
        }
    }
    
    //These are required to enable subclasses to override.
    //TVCWTVDataSource
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int { return 1 }
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.object(at: cell.outerIndexPath).numberOfItems(inSection: section)
    }
    func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return ["cell"]
    }
    func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return [InnerTableViewCell.self]
    }
    func heightForInnerCell(for cell: TableViewCellWithTableView) -> CGFloat {
        return Lets.subTVCellSize
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
    func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { fatalError() }
    
    //TVCWTVDelegate
    func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) { fatalError() }
    func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? { return nil }
    
    func cell(_ cell: TableViewCellWithTableView, didTap button: UIButton) {
        let object = dataProvider.object(at: cell.outerIndexPath)
        let noteVC = NoteVC(object: object, placeholder: "", button: button, callback: nil)
        present(noteVC, animated: true, completion: nil)
    }
    
    func dataProviderDidUpdate(updates: [DataProviderUpdate]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
            case .update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
                cell.configureForObject(object: object as! Type, at: indexPath)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        tableView.endUpdates()
    }
}

















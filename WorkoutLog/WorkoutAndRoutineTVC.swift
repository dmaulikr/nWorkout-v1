import UIKit
import CoreData

class WorkoutAndRoutineTVC<Source: ManagedObject, Type: ManagedObject, Cell: TableViewCellWithTableView>: TableViewController<Source, Type, Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider, Source: DataProvider {
    
    func stringForButton() -> String {
        return Lets.newLiftBarButtonText
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: stringForButton(), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    func addButtonTapped() {
        let nlvc = NewVC(type: Type.self, placeholder: Lets.newLiftPlaceholderText, barButtonItem: navigationItem.rightBarButtonItem!, callback: insertNewObject)
        present(nlvc, animated: true)
    }
    func insertNewObject(object: Type) {
        var newIndexPath: IndexPath?
        context.performAndWait {
            newIndexPath = self.dataProvider.insert(object: object)
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        guard let indexPath = newIndexPath else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError("Editing style == \(editingStyle)") }
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { _ in
            self.dataProvider.managedObjectContext?.performAndWait {
                let object = self.dataProvider.object(at: indexPath)
                self.dataProvider.managedObjectContext?.delete(object)
                do {
                    try self.dataProvider.managedObjectContext!.save()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let outerCell = Cell(delegateAndDataSource: self, indexPath: indexPath)
        let object = dataProvider.object(at: indexPath)
        outerCell.configureForObject(object: object, at: indexPath)
        return outerCell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    //UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) + 1.0) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //TVCWTVDaDS
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 2
    }
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        } else {
            return 1
        }
    }
    func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? {
        if innerIndexPath.section == 1 {
            return innerIndexPath
        } else {
            return nil
        }
    }
    func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) {
        cell.tableView.deselectRow(at: innerIndexPath, animated: true)
        var newInnerIndexPath: IndexPath?
        context.performAndWait {
            let set = Type.Object(context: self.context)
            let lift = self.dataProvider.object(at: cell.indexPath)
            newInnerIndexPath = lift.insert(object: set)
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        guard let indexPath = newInnerIndexPath else { return }
        tableView.beginUpdates()
        cell.tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false } else { return true }
    }
    func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let outerObject = dataProvider.object(at: cell.indexPath)
        let toRemove = outerObject.object(at: indexPath)
        outerObject.remove(object: toRemove)
        
        tableView.beginUpdates()
        cell.tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat {
        return Lets.subTVCellSize
    }
    //Dummy since Swift can't find Subclass implementation without something to override.
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) { fatalError() }
    func thing(innerCell: Int) { }
}

extension WorkoutAndRoutineTVC: TableViewCellWithTableViewDelegateAndDataSource { }


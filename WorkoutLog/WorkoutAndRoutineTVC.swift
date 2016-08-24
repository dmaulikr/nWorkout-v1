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
        tableView.reloadData()
    }
    
    // UITableViewDataSource

    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) + 1) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    
    //TVCWTVDaDS
    override func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 2
    }
    override func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        } else {
            return 1
        }
    }
    override func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? {
        if innerIndexPath.section == 1 {
            return innerIndexPath
        } else {
            return nil
        }
    }
    override func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) {
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
        cell.tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.beginUpdates()
        
        tableView.reloadRows(at: [cell.indexPath], with: .none)
        tableView.endUpdates()
    }
    override func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false } else { return true }
    }
    override func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let outerObject = dataProvider.object(at: cell.indexPath)
        let toRemove = outerObject.object(at: indexPath)
        outerObject.remove(object: toRemove)
        
        tableView.beginUpdates()
        cell.tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    override func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat {
        return Lets.subTVCellSize
    }
    //Dummy since Swift can't find Subclass implementation without something to override.
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) { fatalError() }
    
}



import UIKit
import CoreData

class WorkoutAndRoutineTVC<Source: ManagedObject, Type: ManagedObject, Cell: TableViewCellWithTableView>: TableViewController<Source, Type, Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider, Source: DataProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.numberOfItems(inSection: section)
        } else {
            let newWorkoutNav = (UIApplication.shared.delegate as! AppDelegate).appCoordinator.newWorkoutNav
            return navigationController == newWorkoutNav ? 2 : 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return super.tableView(tableView, cellForRowAt: indexPath)
        } else {
            let cell = InnerTableViewCell()
            switch indexPath.row {
            case 0: cell.textLabel?.text = "Add Lift"
            case 1: cell.textLabel?.text = "Finish Workout"
            default: fatalError()
            }
            return cell
        }
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataProvider.moveObject(at: sourceIndexPath, to: destinationIndexPath)
        setOuterIndexPaths()
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                addButtonTapped()
                tableView.deselectRow(at: indexPath, animated: true)
            default: fatalError()
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    //TVCWTVDaDS
    override func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 2
    }
    override func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.object(at: cell.outerIndexPath).numberOfItems(inSection: section)
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
    func addNewSet(for cell: TableViewCellWithTableView, atInner innerIndexPath: IndexPath) -> InnerTableViewCell {
        cell.deselectRow(at: innerIndexPath, animated: true)
        var newInnerIndexPath: IndexPath?
        context.performAndWait {
            let set = Type.Object(context: self.context)
            let lift = self.dataProvider.object(at: cell.outerIndexPath)
            newInnerIndexPath = lift.insert(object: set)
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        guard let indexPath = newInnerIndexPath else { fatalError() }
        cell.insertRows(at: [indexPath], with: .automatic)
        tableView.beginUpdates()
        
        //        tableView.reloadRows(at: [cell.outerIndexPath], with: .none)
        tableView.endUpdates()
        return cell.innerCellForRow(atInner: indexPath) as! InnerTableViewCell
    }
    override func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) {
        _ = addNewSet(for: cell, atInner: innerIndexPath)
    }
    override func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false } else { return true }
    }
    override func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let outerObject = dataProvider.object(at: cell.outerIndexPath)
        let toRemove = outerObject.object(at: indexPath)
        outerObject.remove(object: toRemove)
        
        tableView.beginUpdates()
        cell.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    //Dummy since Swift can't find Subclass implementation without something to override.
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    override func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return super.cellClassForInnerTableView(for: cell)
    }
    override func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return super.reuseIdentifierForInnerTableView(for: cell)
    }
    
    
}

extension WorkoutAndRoutineTVC: LiftCellDelegate {
    func cellShouldJumpToNewSet(for cell: TableViewCellWithTableView, atInner innerIndexPath: IndexPath) -> InnerTableViewCell {
        return addNewSet(for: cell, atInner: innerIndexPath)
    }
}

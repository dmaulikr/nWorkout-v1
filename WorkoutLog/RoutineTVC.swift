import UIKit
import CoreData

extension Routine: DataProvider {
    func object(at indexPath: IndexPath) -> RoutineLift {
        return lifts!.object(at: indexPath.row) as! RoutineLift
    }
    func insert(object: RoutineLift) -> IndexPath {
        guard let context = managedObjectContext else { assertionFailure("Why doesn't this exist"); return IndexPath() }
        context.performAndWait {
            let set = RoutineSet(context: context)
            set.weight = 225
            set.reps = 5
            object.addToSets(set)
            self.addToLifts(object)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        return IndexPath(row: lifts!.count - 1, section: 0)
    }
    func index(of object: RoutineLift) -> IndexPath {
        return IndexPath(row: lifts!.index(of: object), section: 0)
    }
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int) -> Int {
        return lifts!.count
    }
}


class RoutineTVC: TVCWithTVDS<Routine, RoutineLift, RoutineLiftCell> {

    func stringForButton() -> String {
        return Lets.newLiftBarButtonText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController!.viewControllers[1] is SelectWorkoutTVC {
            navigationController!.viewControllers.remove(at: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: stringForButton(), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    func addButtonTapped() {
        let nlvc = NewVC(type: RoutineLift.self, placeholder: Lets.newLiftPlaceholderText, barButtonItem: navigationItem.rightBarButtonItem!, callback: insertNewObject)
        present(nlvc, animated: true)
    }
    
    func insertNewObject(object: RoutineLift) {
        var newIndexPath: IndexPath?
        
        context.performAndWait {
            newIndexPath = self.dataProvider.insert(object: object)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
        guard let indexPath = newIndexPath else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func canEditRow(at: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.dataProvider.managedObjectContext?.performAndWait {
                let object = self.dataSource.dataProvider.object(at: indexPath)
                self.dataSource.dataProvider.managedObjectContext?.delete(object)
                do {
                    try self.dataSource.dataProvider.managedObjectContext!.save()
                } catch let error {
                    print(error)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }


}

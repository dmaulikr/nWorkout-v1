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


class RoutineTVC: TVCWithTableViewInCells<Routine, RoutineLift, RoutineLiftCell> {

    override func stringForButton() -> String {
        return "New Lift"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        observeNotification(named: "routineSetChanged")
    }
    
    override func cellIdentifier(for object: RoutineLift) -> String {
        return "routineLiftCell"
    }
    override func cellIdentifierForRegistration(for cell: RoutineLiftCell.Type) -> String {
        return "routineLiftCell"
    }

}

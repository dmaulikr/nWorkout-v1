import UIKit
import CoreData

extension Workout: DataProvider {
    func object(at indexPath: IndexPath) -> Lift {
        return lifts!.object(at: indexPath.row) as! Lift
    }
    func insert(object: Lift) -> IndexPath {
        guard let context = managedObjectContext else { assertionFailure("Why doesn't this exist"); return IndexPath() }
        context.performAndWait {
            object.name = "Squat"
            let set = LSet(context: context)
            set.targetWeight = 225
            set.targetReps = 5
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
    func index(of object: Lift) -> IndexPath {
        return IndexPath(row: lifts!.index(of: object), section: 0)
    }
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int) -> Int {
        return lifts!.count
    }
}


class WorkoutTVC: TVCWithTableViewInCells<Workout, Lift, LiftCell> {
    
    override func stringForButton() -> String {
        return "New Lift"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationController!.viewControllers[1] is SelectWorkoutTVC {
            navigationController!.viewControllers.remove(at: 1)
        }
        
        observeNotification(named: "setChanged")
    }
    
    override func cellIdentifier(for object: Lift) -> String {
        return "liftCell"
    }
    override func cellIdentifierForRegistration(for cell: LiftCell.Type) -> String {
        return "liftCell"
    }
}


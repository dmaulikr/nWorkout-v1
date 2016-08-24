import Foundation
import CoreData

@objc(Routine)
public class Routine: ManagedObject {

}

extension Routine: ManagedObjectType {
    public static var entityName: String {
        return "Routine"
    }
    
    func toWorkout() -> Workout {
        let workout = Workout(context: managedObjectContext!)
        let lfts = lifts!.map { ($0 as! RoutineLift).toLift() }
        for lift in lfts {
            workout.addToLifts(lift)
        }
        return workout
    }
}

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
                print(error: error)
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

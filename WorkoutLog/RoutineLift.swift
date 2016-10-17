import Foundation
import CoreData

@objc(RoutineLift)
public class RoutineLift: ManagedObject {

}

extension RoutineLift: ManagedObjectType {
    public static var entityName: String {
        return "RoutineLift"
    }
    
    func toLift() -> WorkoutLift {
        let lift = WorkoutLift(context: managedObjectContext!)
        let sts = sets!.map { ($0 as! RoutineSet).toSet() }
        for set in sts {
            lift.addToSets(set)
        }
        lift.name = name
        return lift
    }
}

extension RoutineLift: DataProvider {
    
    func object(at: IndexPath) -> RoutineSet {
        return sets!.object(at: at.row) as! RoutineSet
    }
    func numberOfItems(inSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        if let sets = sets {
            return sets.count
        } else {
            return 0
        }
    }
    func numberOfSections() -> Int {
        return 2
    }
    func insert(object: RoutineSet) -> IndexPath {
        managedObjectContext?.performAndWait {
            self.addToSets(object)
            do {
                try self.managedObjectContext?.save()
            } catch {
                print(error: error)
            }
        }
        let row = sets?.count ?? 1
        return IndexPath(row: row - 1, section: 0)
    }
    func remove(object: RoutineSet) {
        managedObjectContext?.performAndWait {
            self.removeFromSets(object)
            do {
                try self.managedObjectContext?.save()
            } catch {
                print(error: error)
            }
        }
    }
}

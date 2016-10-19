import Foundation
import CoreData

@objc(WorkoutLift)
public class WorkoutLift: Lift {
    var date: Date {
        return workout!.date! 
    }
}

extension WorkoutLift: ManagedObjectType {
    public static var entityName: String {
        return "WorkoutLift"
    }
}

extension WorkoutLift: DataProvider {
    
    func object(at indexPath: IndexPath) -> WorkoutSet {
        guard let sets = sets else { fatalError() }
        return sets.object(at: indexPath.row) as! WorkoutSet
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
    func insert(object: WorkoutSet) -> IndexPath {
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
    func remove(object: WorkoutSet) {
        managedObjectContext?.performAndWait {
            self.removeFromSets(object)
            object.managedObjectContext?.delete(object)
            do {
                try self.managedObjectContext?.save()
            } catch {
                print(error: error)
            }
        }
    }
}

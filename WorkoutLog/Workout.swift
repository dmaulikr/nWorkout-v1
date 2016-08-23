import Foundation
import CoreData

@objc(Workout)
public class Workout: ManagedObject {

}

extension Workout: ManagedObjectType {
    public static var entityName: String {
        return "Workout"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}

extension Workout: DataProvider {
    func object(at indexPath: IndexPath) -> Lift {
        return lifts!.object(at: indexPath.row) as! Lift
    }
    func insert(object: Lift) -> IndexPath {
        guard let context = managedObjectContext else { assertionFailure("Why doesn't this exist"); return IndexPath() }
        context.performAndWait {
            let set = LSet(context: context)
            set.targetWeight = 225
            set.targetReps = 5
            object.addToSets(set)
            self.addToLifts(object)
            do {
                try context.save()
            } catch {
                print("===============ERROR==============")
                print(error)
            }
        }
        return IndexPath(row: lifts!.count - 1, section: 0)
    }
    func index(of object: Lift) -> IndexPath {
        print(object)
        print(lifts!.index(of: object))
        return IndexPath(row: lifts!.index(of: object), section: 0)
    }
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int) -> Int {
        return lifts!.count
    }
}
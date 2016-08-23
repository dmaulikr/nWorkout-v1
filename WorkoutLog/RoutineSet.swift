import Foundation
import CoreData

@objc(RoutineSet)
public class RoutineSet: ManagedObject {

}

extension RoutineSet: ManagedObjectType {
    public static var entityName: String {
        return "RoutineSet"
    }
    
    func toSet() -> LSet {
        let lSet = LSet(context: managedObjectContext!)
        lSet.targetWeight = weight
        lSet.targetReps = reps
        return lSet
    }
}

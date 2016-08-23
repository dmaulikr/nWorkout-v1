import Foundation
import CoreData

@objc(RoutineLift)
public class RoutineLift: ManagedObject {

}

extension RoutineLift: ManagedObjectType {
    public static var entityName: String {
        return "RoutineLift"
    }
    
    func toLift() -> Lift {
        let lift = Lift(context: managedObjectContext!)
        let sts = sets!.map { ($0 as! RoutineSet).toSet() }
        for set in sts {
            lift.addToSets(set)
        }
        lift.name = name
        return lift
    }
}

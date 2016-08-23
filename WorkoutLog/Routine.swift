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

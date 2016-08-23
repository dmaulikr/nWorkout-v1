import Foundation
import CoreData

extension RoutineSet {

    @NSManaged public var reps: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var lift: RoutineLift?

}

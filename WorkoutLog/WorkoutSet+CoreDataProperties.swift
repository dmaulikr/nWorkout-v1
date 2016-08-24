import Foundation
import CoreData

extension WorkoutSet {

    @NSManaged public var completedReps: Int16
    @NSManaged public var completedWeight: Int16
    @NSManaged public var status: Int16
    @NSManaged public var targetReps: Int16
    @NSManaged public var targetWeight: Int16
    @NSManaged public var lift: WorkoutLift?

}

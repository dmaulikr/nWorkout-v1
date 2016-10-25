import CoreData


extension WorkoutSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutSet> {
        return NSFetchRequest<WorkoutSet>(entityName: "WorkoutSet");
    }

    @NSManaged public var completedReps: Int16
    @NSManaged public var completedWeight: Int16
    @NSManaged public var note: String?
    @NSManaged public var status: Int16
    @NSManaged public var targetReps: Int16
    @NSManaged public var targetWeight: Int16
    @NSManaged public var lift: WorkoutLift?
    @NSManaged public var warmup: Bool

}

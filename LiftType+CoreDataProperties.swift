import CoreData


extension LiftType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiftType> {
        return NSFetchRequest<LiftType>(entityName: "LiftType");
    }

    @NSManaged public var name: String?
    @NSManaged public var routineLifts: NSSet?
    @NSManaged public var workoutLifts: NSSet?

}

// MARK: Generated accessors for routineLifts
extension LiftType {

    @objc(addRoutineLiftsObject:)
    @NSManaged public func addToRoutineLifts(_ value: RoutineLift)

    @objc(removeRoutineLiftsObject:)
    @NSManaged public func removeFromRoutineLifts(_ value: RoutineLift)

    @objc(addRoutineLifts:)
    @NSManaged public func addToRoutineLifts(_ values: NSSet)

    @objc(removeRoutineLifts:)
    @NSManaged public func removeFromRoutineLifts(_ values: NSSet)

}

// MARK: Generated accessors for workoutLifts
extension LiftType {

    @objc(addWorkoutLiftsObject:)
    @NSManaged public func addToWorkoutLifts(_ value: WorkoutLift)

    @objc(removeWorkoutLiftsObject:)
    @NSManaged public func removeFromWorkoutLifts(_ value: WorkoutLift)

    @objc(addWorkoutLifts:)
    @NSManaged public func addToWorkoutLifts(_ values: NSSet)

    @objc(removeWorkoutLifts:)
    @NSManaged public func removeFromWorkoutLifts(_ values: NSSet)

}

import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout");
    }

    @NSManaged public var complete: Bool
    @NSManaged public var date: Date?
    @NSManaged public var finishDate: Date?
    @NSManaged public var note: String?
    @NSManaged public var lifts: NSOrderedSet?

}

// MARK: Generated accessors for lifts
extension Workout {

    @objc(insertObject:inLiftsAtIndex:)
    @NSManaged public func insertIntoLifts(_ value: WorkoutLift, at idx: Int)

    @objc(removeObjectFromLiftsAtIndex:)
    @NSManaged public func removeFromLifts(at idx: Int)

    @objc(insertLifts:atIndexes:)
    @NSManaged public func insertIntoLifts(_ values: [WorkoutLift], at indexes: NSIndexSet)

    @objc(removeLiftsAtIndexes:)
    @NSManaged public func removeFromLifts(at indexes: NSIndexSet)

    @objc(replaceObjectInLiftsAtIndex:withObject:)
    @NSManaged public func replaceLifts(at idx: Int, with value: WorkoutLift)

    @objc(replaceLiftsAtIndexes:withLifts:)
    @NSManaged public func replaceLifts(at indexes: NSIndexSet, with values: [WorkoutLift])

    @objc(addLiftsObject:)
    @NSManaged public func addToLifts(_ value: WorkoutLift)

    @objc(removeLiftsObject:)
    @NSManaged public func removeFromLifts(_ value: WorkoutLift)

    @objc(addLifts:)
    @NSManaged public func addToLifts(_ values: NSOrderedSet)

    @objc(removeLifts:)
    @NSManaged public func removeFromLifts(_ values: NSOrderedSet)

}

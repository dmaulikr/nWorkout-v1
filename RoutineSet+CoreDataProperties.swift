import CoreData

extension RoutineSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineSet> {
        return NSFetchRequest<RoutineSet>(entityName: "RoutineSet");
    }

    @NSManaged public var note: String?
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var lift: RoutineLift?

}

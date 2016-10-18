import CoreData

@objc(LiftType)
public class LiftType: ManagedObject {
}

extension LiftType: ManagedObjectType {
    public static var entityName: String {
        return "LiftType"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}


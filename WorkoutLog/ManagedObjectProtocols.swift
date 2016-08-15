import Foundation
import CoreData

public protocol ManagedObjectType: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var defaultPredicate: NSPredicate { get }
    var managedObjectContext: NSManagedObjectContext? { get }
}


extension ManagedObjectType {
    public static var request: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var defaultPredicate: NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }
}

extension Workout: ManagedObjectType {
    public static var entityName: String {
        return "Workout"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}


extension Lift: ManagedObjectType {
    public static var entityName: String {
        return "Lift"
    }
}

extension Routine: ManagedObjectType {
    public static var entityName: String {
        return "Routine"
    }
}

extension RoutineLift: ManagedObjectType {
    public static var entityName: String {
        return "RoutineLift"
    }
}

extension RoutineSet: ManagedObjectType {
    public static var entityName: String {
        return "RoutineSet"
    }
}
extension LSet: ManagedObjectType {
    public static var entityName: String {
        return "LSet"
    }
    
    var setStatus: SetStatus {
        get {
            switch status {
            case 1: return .incomplete
            case 2: return .done
            case 3: return .fail
            case 4: return .skip
            default: return .incomplete
            }
        }
        set {
            switch newValue {
            case .incomplete: status = 1
            case .done: status = 2
            case .fail: status = 3
            case .skip: status = 4
            }
        }
    }
}

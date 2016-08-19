import CoreData

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
    
    func toWorkout() -> Workout {
        let workout = Workout(context: managedObjectContext!)
        let lfts = lifts!.map { ($0 as! RoutineLift).toLift() }
        for lift in lfts {
            workout.addToLifts(lift)
        }
        return workout
    }
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

extension RoutineSet: ManagedObjectType {
    public static var entityName: String {
        return "RoutineSet"
    }
    
    func toSet() -> LSet {
        let lSet = LSet(context: managedObjectContext!)
        lSet.targetWeight = weight
        lSet.targetReps = reps
        return lSet
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

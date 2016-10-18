import Foundation
import CoreData


extension WorkoutSet: SetType {
    var settableWeight: Int {
        set { targetWeight = Int16(newValue) }
        get { return Int(targetWeight) }
    }
    var settableReps: Int {
        set { targetReps = Int16(newValue) }
        get { return Int(targetReps) }
    }
}

@objc(WorkoutSet)
public class WorkoutSet: ManagedObject {

}

extension WorkoutSet: ManagedObjectType {
    public static var entityName: String {
        return "WorkoutSet"
    }
    
    var setStatus: SetStatus {
        get {
            switch status {
            case 1: return .incomplete
            case 2: return .done
            case 3: return .fail
            default: return .incomplete
            }
        }
        set {
            switch newValue {
            case .incomplete: status = 1
            case .done: status = 2
            case .fail: status = 3
            }
        }
    }
}

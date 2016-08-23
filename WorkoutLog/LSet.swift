import Foundation
import CoreData

@objc(LSet)
public class LSet: ManagedObject {

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

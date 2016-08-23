import Foundation
import CoreData

@objc(Lift)
public class Lift: ManagedObject {

}

extension Lift: ManagedObjectType {
    public static var entityName: String {
        return "Lift"
    }
}

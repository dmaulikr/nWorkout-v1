import Foundation
import CoreData

extension Workout {

    @NSManaged public var complete: Bool
    @NSManaged public var date: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var lifts: NSOrderedSet?

}

// MARK: Generated accessors for lifts
extension Workout {

    @objc(insertObject:inLiftsAtIndex:)
    @NSManaged public func insertIntoLifts(_ value: Lift, at idx: Int)

    @objc(removeObjectFromLiftsAtIndex:)
    @NSManaged public func removeFromLifts(at idx: Int)

    @objc(insertLifts:atIndexes:)
    @NSManaged public func insertIntoLifts(_ values: [Lift], at indexes: NSIndexSet)

    @objc(removeLiftsAtIndexes:)
    @NSManaged public func removeFromLifts(at indexes: NSIndexSet)

    @objc(replaceObjectInLiftsAtIndex:withObject:)
    @NSManaged public func replaceLifts(at idx: Int, with value: Lift)

    @objc(replaceLiftsAtIndexes:withLifts:)
    @NSManaged public func replaceLifts(at indexes: NSIndexSet, with values: [Lift])

    @objc(addLiftsObject:)
    @NSManaged public func addToLifts(_ value: Lift)

    @objc(removeLiftsObject:)
    @NSManaged public func removeFromLifts(_ value: Lift)

    @objc(addLifts:)
    @NSManaged public func addToLifts(_ values: NSOrderedSet)

    @objc(removeLifts:)
    @NSManaged public func removeFromLifts(_ values: NSOrderedSet)

}

import Foundation
import CoreData

extension Lift {

    @NSManaged public var expanded: Bool
    @NSManaged public var name: String?
    @NSManaged public var sets: NSOrderedSet?
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for sets
extension Lift {

    @objc(insertObject:inSetsAtIndex:)
    @NSManaged public func insertIntoSets(_ value: LSet, at idx: Int)

    @objc(removeObjectFromSetsAtIndex:)
    @NSManaged public func removeFromSets(at idx: Int)

    @objc(insertSets:atIndexes:)
    @NSManaged public func insertIntoSets(_ values: [LSet], at indexes: NSIndexSet)

    @objc(removeSetsAtIndexes:)
    @NSManaged public func removeFromSets(at indexes: NSIndexSet)

    @objc(replaceObjectInSetsAtIndex:withObject:)
    @NSManaged public func replaceSets(at idx: Int, with value: LSet)

    @objc(replaceSetsAtIndexes:withSets:)
    @NSManaged public func replaceSets(at indexes: NSIndexSet, with values: [LSet])

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: LSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: LSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSOrderedSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}

//
//  RoutineLift+CoreDataProperties.swift
//  WorkoutLog
//
//  Created by Nathan Lanza on 8/23/16.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import Foundation
import CoreData

extension RoutineLift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineLift> {
        return NSFetchRequest<RoutineLift>(entityName: "RoutineLift");
    }

    @NSManaged public var name: String?
    @NSManaged public var routine: Routine?
    @NSManaged public var sets: NSOrderedSet?

}

// MARK: Generated accessors for sets
extension RoutineLift {

    @objc(insertObject:inSetsAtIndex:)
    @NSManaged public func insertIntoSets(_ value: RoutineSet, at idx: Int)

    @objc(removeObjectFromSetsAtIndex:)
    @NSManaged public func removeFromSets(at idx: Int)

    @objc(insertSets:atIndexes:)
    @NSManaged public func insertIntoSets(_ values: [RoutineSet], at indexes: NSIndexSet)

    @objc(removeSetsAtIndexes:)
    @NSManaged public func removeFromSets(at indexes: NSIndexSet)

    @objc(replaceObjectInSetsAtIndex:withObject:)
    @NSManaged public func replaceSets(at idx: Int, with value: RoutineSet)

    @objc(replaceSetsAtIndexes:withSets:)
    @NSManaged public func replaceSets(at indexes: NSIndexSet, with values: [RoutineSet])

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: RoutineSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: RoutineSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSOrderedSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}

import UIKit
import CoreData

extension Routine: DataProvider {
    func object(at indexPath: IndexPath) -> RoutineLift {
        return lifts!.object(at: indexPath.row) as! RoutineLift
    }
    func insert(object: RoutineLift) -> IndexPath {
        guard let context = managedObjectContext else { assertionFailure("Why doesn't this exist"); return IndexPath() }
        context.performAndWait {
            let set = RoutineSet(context: context)
            set.weight = 225
            set.reps = 5
            object.addToSets(set)
            self.addToLifts(object)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        return IndexPath(row: lifts!.count - 1, section: 0)
    }
    func index(of object: RoutineLift) -> IndexPath {
        return IndexPath(row: lifts!.index(of: object), section: 0)
    }
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int) -> Int {
        return lifts!.count
    }
}

extension RoutineLift: DataProvider {
    typealias Object = RoutineSet
    func object(at indexPath: IndexPath) -> RoutineSet {
        guard let sets = sets else { fatalError() }
        return sets.object(at: indexPath.row) as! RoutineSet
    }
    func numberOfItems(inSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        if let sets = sets {
            return sets.count
        } else {
            return 0
        }
    }
    func numberOfSections() -> Int {
        return 2
    }
}

extension RoutineLiftCell: ConfigurableCell {
    func configureForObject(object: RoutineLift, at indexPath: IndexPath) {
        //
    }
}


class RoutineTVC: TVCWithTableViewCellWithTableView<Routine, RoutineLift, RoutineLiftCell> {
    
    override func stringForButton() -> String {
        return Lets.newLiftBarButtonText
    }
    
    
    override func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let num = dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
            cell.heightConstraint.constant = CGFloat(num + 1) * CGFloat(Lets.subTVCellSize)
            return num
        } else {
            return 1
        }
    }
    
    override func cell(forRowAt indexPath: IndexPath, identifier: String) -> RoutineLiftCell? {
        return RoutineLiftCell(delegateAndDataSource: self, indexPath: indexPath, subTableViewCellType: RoutineSetCell.self)
    }
    
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoutineSetCell
        
        let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        tvcell.textLabel?.text = lift.description
        return tvcell
    }
}

extension RoutineTVC {
    func cell(_ cell: TableViewCellWithTableView, didSelectRowAt indexPath: IndexPath) {
        let lift = dataProvider.object(at: indexPath)
        
        context.performAndWait {
            let newSet = RoutineSet(context: self.context)
            newSet.weight = (lift.sets?.lastObject as? RoutineSet)?.weight ?? 0
            newSet.reps = (lift.sets?.lastObject as? RoutineSet)?.reps ?? 0
            
            lift.addToSets(newSet)
            try! self.context.save()
        }
    }
}













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

extension RoutineLiftCell: ConfigurableCell {
    func configureForObject(object: RoutineLift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        backgroundColor = nil
    }
}

extension RoutineLift: DataProvider {
    
    func object(at: IndexPath) -> RoutineSet {
        return sets!.object(at: at.row) as! RoutineSet
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
    func insert(object: RoutineSet) -> IndexPath {
        managedObjectContext?.performAndWait {
            self.addToSets(object)
            object.reps = 6
            object.weight = 225
            do {
                try self.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        let row = sets?.count ?? 1
        return IndexPath(row: row - 1, section: 0)
    }
    func remove(object: RoutineSet) {
        managedObjectContext?.performAndWait {
            self.removeFromSets(object)
            do {
                try self.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
    }
}

class RoutineTVC: WorkoutAndRoutineTVC<Routine, RoutineLift, RoutineLiftCell> {

    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoutineSetCell
        if indexPath.section == 1 {
            innerCell.textLabel?.text = Lets.addSetText
            innerCell.textFields.forEach { $0.isHidden = true }
        } else {
            let set = dataProvider.object(at: cell.indexPath).object(at: indexPath)
            innerCell.configureForObject(object: set, at: indexPath)
        }
        return innerCell
    }
    override func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        cell.tableView.register(RoutineSetCell.self, forCellReuseIdentifier: "cell")
    }

}



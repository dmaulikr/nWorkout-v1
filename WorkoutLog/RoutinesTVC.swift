import UIKit
import CoreData

class RoutinesTVC: CoreDataTVC<Routine, RoutineCell> {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rtvc = segue.destination as! RoutineTVC
        switch segue.identifier! {
        case "showRoutine":
            guard let routine = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            rtvc.routine = routine
        case "newRoutine":
            rtvc.routine = Routine(context: context)
            rtvc.routine.name = "New routine"
        default: fatalError("No segue identifier for \(segue.identifier)")
        }
    }

    override func cellIdentifier(for object: Routine) -> String {
        return "routineCell"
    }
    override func cellIdentifierForRegistration(for cell: RoutineCell.Type) -> String {
        return "routineCell"
    }
}

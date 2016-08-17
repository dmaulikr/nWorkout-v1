import UIKit
import CoreData

class RoutinesTVC: CoreDataTVC<Routine, RoutineCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Routine", style: .plain, target: self, action: #selector(newRoutine))
    }
    
    func newRoutine() {
        let rtvc = RoutineTVC(style: .plain)
        rtvc.source = Routine(context: context)
        rtvc.source.name = "Starting Strength A"
        navigationController?.pushViewController(rtvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rtvc = RoutineTVC()
        rtvc.source = dataSource.selectedObject
        navigationController?.pushViewController(rtvc, animated: true)
    }
    
    // DataSourceDelegate
    override func cellIdentifier(for object: Routine) -> String {
        return "routineCell"
    }
    override func cellIdentifierForRegistration(for cell: RoutineCell.Type) -> String {
        return "routineCell"
    }
}

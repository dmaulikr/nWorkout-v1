import UIKit
import CoreData


class RoutinesTVC: CDTVCWithTVDS<Routine, RoutineCell>, UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Routine", style: .plain, target: self, action: #selector(newRoutine))
    }
    
    func newRoutine() {
        let nrtvc = NewVC(type: Routine.self, placeholder: "Insert new routine name", barButtonItem: navigationItem.rightBarButtonItem!) { object in }
        present(nrtvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rtvc = RoutineTVC(dataProvider: dataSource.selectedObject!)
        navigationController?.pushViewController(rtvc, animated: true)
    }
    
    // DataSourceDelegate
    override func cellIdentifier(for object: Routine) -> String {
        return "routineCell"
    }
    override func cellIdentifierForRegistration(for cell: RoutineCell.Type) -> String {
        return "routineCell"
    }
    
    
    override func canEditRow(at indexPath: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = dataSource.dataProvider.object(at: indexPath)
            object.managedObjectContext!.performAndWait {
                object.managedObjectContext!.delete(object)
                do {
                    try object.managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
            
        }
    }
}

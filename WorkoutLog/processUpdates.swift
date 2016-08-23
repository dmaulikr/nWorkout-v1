import UIKit

//
//    func processUpdates(updates: [DataProviderUpdate]?) {
//        guard let updates = updates else { return tableView.reloadData() }
//        tableView.beginUpdates()
//        for update in updates {
//            switch update {
//            case .insert(let indexPath):
//                tableView.insertRows(at: [indexPath], with: .fade)
//            case .update(let indexPath, let object):
//                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
//                cell.configureForObject(object: object as! Delegate.Object, at: indexPath)
//            case .move(let indexPath, let newIndexPath):
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.insertRows(at: [newIndexPath], with: .fade)
//            case .delete(let indexPath):
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }
//        tableView.endUpdates()
//    }

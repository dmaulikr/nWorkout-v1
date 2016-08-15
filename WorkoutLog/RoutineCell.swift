import UIKit

class RoutineCell: UITableViewCell {
    
}

extension RoutineCell: ConfigurableCell {
    func configureForObject(object: Routine, at indexPath: IndexPath) {
        textLabel?.text = "\(object.name!)"
    }
}

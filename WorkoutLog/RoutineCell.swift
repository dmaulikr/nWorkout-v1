import UIKit

class RoutineCell: UITableViewCell {
    
}

extension RoutineCell: ConfigurableCell {
    func configureForObject(object: Routine) {
        textLabel?.text = "\(object.name!)"
    }
}

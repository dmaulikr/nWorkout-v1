import UIKit

class RoutineCell: TableViewCellWithTableView {
    
}

extension RoutineCell: ConfigurableCell {
    func configureForObject(object: Routine, at indexPath: IndexPath) {
        textLabel?.text = "\(object.name!)"
    }
}

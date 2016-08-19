import UIKit

class RoutineCell: WorkoutAndRoutineCell<Routine>, ConfigurableCell {
    func configureForObject(object: Routine, at indexPath: IndexPath) {
        nameLabel.text = object.name!
    }
}


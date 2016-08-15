import UIKit

class WorkoutCell: UITableViewCell {

}

extension WorkoutCell: ConfigurableCell {
    func configureForObject(object: Workout) {
        textLabel?.text = "\(object.date!)"
    }
}

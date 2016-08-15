import UIKit

class WorkoutCell: UITableViewCell {

}

extension WorkoutCell: ConfigurableCell {
    func configureForObject(object: Workout, at indexPath: IndexPath) {
        textLabel?.text = "\(object.date!)"
    }
}

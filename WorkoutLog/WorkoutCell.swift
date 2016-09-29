import UIKit

class WorkoutCell: NamedTVCWTV<Workout> {
    override func configureForObject(object: Workout, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        guard let date = object.date else { return }
        nameLabel.text = Lets.df.string(from: date)
    }
}



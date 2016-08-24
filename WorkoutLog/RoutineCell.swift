import UIKit

class RoutineCell: NamedTVCWTV<Routine> {
    override func configureForObject(object: Routine, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        nameLabel.text = object.name!
    }
}


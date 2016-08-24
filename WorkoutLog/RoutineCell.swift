import UIKit

class RoutineCell: NamedTVCWTV<Routine>, ConfigurableCell {
    func configureForObject(object: Routine, at indexPath: IndexPath) {
        nameLabel.text = object.name!
    }
}


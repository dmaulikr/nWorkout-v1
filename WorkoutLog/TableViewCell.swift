import UIKit

class TableViewCell: UITableViewCell {

}

extension TableViewCell: ConfigurableCell {
    func configureForObject(object: Workout) {
        textLabel?.text = "\(object.date!)"
    }
}

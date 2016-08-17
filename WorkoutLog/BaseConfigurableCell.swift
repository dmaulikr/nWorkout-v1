import UIKit

class BaseConfigurableCell<DataSource>: UITableViewCell, ConfigurableCell {
    func configureForObject(object: DataSource, at indexPath: IndexPath) {
        print("You shouldn't be using this.")
    }
}

import UIKit

class BaseConfigurableCell<DataSource>: UITableView, ConfigurableCell {
    func configureForObject(object: DataSource, at indexPath: IndexPath) {
        print("You shouldn't be using this.")
    }
}

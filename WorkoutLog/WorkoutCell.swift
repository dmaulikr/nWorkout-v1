import UIKit

class WorkoutCell: UITableViewCell {

}

extension WorkoutCell: ConfigurableCell {
    func configureForObject(object: Workout, at indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = Lets.dateString
        formatter.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        textLabel?.text = formatter.string(from: object.date! as Date)
    }
}



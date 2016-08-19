import UIKit

class WorkoutCell: WorkoutAndRoutineCell<Workout>, ConfigurableCell {
    func configureForObject(object: Workout, at indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = Lets.dateString
        formatter.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        guard let date = object.date else { return }
        nameLabel.text = formatter.string(from: date as Date)
    }
}



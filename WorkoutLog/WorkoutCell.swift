import UIKit

class WorkoutCell: NamedTVCWTV<Workout> {
    override func configureForObject(object: Workout, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = Lets.dateString
        formatter.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        guard let date = object.date else { return }
        nameLabel.text = formatter.string(from: date as Date)
    }
}



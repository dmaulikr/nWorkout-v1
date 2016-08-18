import UIKit

class WorkoutCell: TableViewCellWithTableView {
    var nameLabel: UILabel
    override init(delegateAndDataSource: TableViewCellWithTableViewDelegate & TableViewCellWithTableViewDataSource, indexPath: IndexPath) {
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 35))
        super.init(delegateAndDataSource: delegateAndDataSource, indexPath: indexPath)
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutCell: ConfigurableCell {
    func configureForObject(object: Workout, at indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = Lets.dateString
        formatter.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        guard let date = object.date else { return }
        nameLabel.text = formatter.string(from: date as Date)
        tableView.isScrollEnabled = false
    }
}



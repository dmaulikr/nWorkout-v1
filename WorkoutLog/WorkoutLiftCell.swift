import UIKit
import CoreData


class WorkoutLiftCell: NamedTVCWTV<WorkoutLift> {
    var topLabelStackView: UIStackView!
    var bottomLabelStackView: UIStackView!
}

extension WorkoutLiftCell: ConfigurableCell {
    
    func configureForObject(object: WorkoutLift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        setupTableLabels()
    }
    
    func setupTableLabels() {
        let twLabel = Label(tableHeaderStyleWith: "Weight")
        let trLabel = Label(tableHeaderStyleWith: "Reps")
        let cwLabel = Label(tableHeaderStyleWith: "Weight")
        let crLabel = Label(tableHeaderStyleWith: "Reps")
        let statusLabel = Label(tableHeaderStyleWith: "Status")
        let bottomLabels = [twLabel,trLabel,cwLabel,crLabel, statusLabel]
        bottomLabelStackView = StackView(arrangedSubviews: bottomLabels, axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        let targetLabel = Label(tableHeaderStyleWith: "Target", borderColor: nil, borderWidth: 0)
        let completedLabel = Label(tableHeaderStyleWith: "Completed", borderColor: nil, borderWidth: 0)
        let topLabels = [targetLabel,completedLabel]
        topLabelStackView = StackView(arrangedSubviews: topLabels, axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        contentView.addSubview(bottomLabelStackView)
        bottomLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomLabelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer).isActive = true
        bottomLabelStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Lets.buffer).isActive = true
        bottomLabelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2).isActive = true
        bottomLabelStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
        contentView.addSubview(topLabelStackView)
        topLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        topLabelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer).isActive = true
        topLabelStackView.widthAnchor.constraint(equalTo: bottomLabelStackView.widthAnchor, multiplier: 0.8).isActive = true
        topLabelStackView.bottomAnchor.constraint(equalTo: bottomLabelStackView.topAnchor).isActive = true
        topLabelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2).isActive = true
    }
}

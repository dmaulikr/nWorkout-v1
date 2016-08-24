import UIKit
import CoreData



class RoutineLiftCell: NamedTVCWTV<RoutineLift> {
    var labelStackView: UIStackView!
}

extension RoutineLiftCell: ConfigurableCell {
    func configureForObject(object: RoutineLift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        setupTableLabels()
    }
    
    func setupTableLabels() {
        let weightLabel = Label(tableHeaderStyleWith: "Weight")
        let repsLabel = Label(tableHeaderStyleWith: "Reps")
        let labels = [weightLabel,repsLabel]
        
        labelStackView = StackView(arrangedSubviews: labels, axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        contentView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer).isActive = true
        labelStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Lets.buffer).isActive = true
        labelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
    }
}


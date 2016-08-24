import UIKit
import CoreData



class RoutineLiftCell: NamedTVCWTV<RoutineLift> {
    var labelStackView: UIStackView!
    
    override func configureForObject(object: RoutineLift, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        nameLabel.text = object.name
        setupTableLabels()
    }
}

extension RoutineLiftCell {

    
    func setupTableLabels() {
        let weightLabel = Label(tableHeaderStyleWith: "Weight")
        let repsLabel = Label(tableHeaderStyleWith: "Reps")
        let labels = [weightLabel,repsLabel]
        
        labelStackView = StackView(arrangedSubviews: labels, axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        contentView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(labelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer))
        constraints.append(labelStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Lets.buffer))
        constraints.append(labelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2))
        constraints.append(labelStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}


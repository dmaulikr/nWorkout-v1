import UIKit
import CoreData

class RoutineLiftCell: NamedTVCWTV<RoutineLift> {
    var labelStackView: UIStackView!
    
    override func configureForObject(object: RoutineLift, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        nameLabel.text = object.name
        setupTableLabels()
        selectionStyle = .none
    }
}

extension RoutineLiftCell {

    
    func setupTableLabels() {
        let weightLabel = UILabel(tableHeaderStyleWith: "Weight")
        let repsLabel = UILabel(tableHeaderStyleWith: "Reps")
        let labels = [weightLabel,repsLabel]
        
        labelStackView = UIStackView(arrangedSubviews: labels, axis: .horizontal, spacing: 0, distribution: .fillEqually)

        topContentView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(labelStackView.leftAnchor.constraint(equalTo: topContentView.leftAnchor))
        constraints.append(labelStackView.rightAnchor.constraint(equalTo: topContentView.rightAnchor))
        constraints.append(labelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2))
        constraints.append(labelStackView.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

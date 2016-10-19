import UIKit
import CoreData




class WorkoutLiftCell: NamedTVCWTV<WorkoutLift> {
    var topLabelStackView: UIStackView!
    var bottomLabelStackView: UIStackView!
    
    override func configureForObject(object: WorkoutLift, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        nameLabel.text = object.name
        setupTableLabels()
        selectionStyle = .none
    }
    weak var liftCellDelegate: LiftCellDelegate!
}

extension WorkoutLiftCell {
    func setupTableLabels() {
        let twLabel = UILabel(tableHeaderStyleWith: "Weight")
        let trLabel = UILabel(tableHeaderStyleWith: "Reps")
        let cwLabel = UILabel(tableHeaderStyleWith: "Weight")
        let crLabel = UILabel(tableHeaderStyleWith: "Reps")
        let statusLabel = UILabel(tableHeaderStyleWith: "Status")
        let bottomLabels = [twLabel,trLabel,cwLabel,crLabel, statusLabel]
        bottomLabelStackView = UIStackView(arrangedSubviews: bottomLabels, axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        let targetLabel = UILabel(tableHeaderStyleWith: "Target", borderColor: nil, borderWidth: 0)
        let completedLabel = UILabel(tableHeaderStyleWith: "Completed", borderColor: nil, borderWidth: 0)
        let topLabels = [targetLabel,completedLabel]
        topLabelStackView = UIStackView(arrangedSubviews: topLabels, axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        var constraints = [NSLayoutConstraint]()
        
        topContentView.addSubview(bottomLabelStackView)
        bottomLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(bottomLabelStackView.leftAnchor.constraint(equalTo:topContentView.leftAnchor))
        constraints.append(bottomLabelStackView.rightAnchor.constraint(equalTo: topContentView.rightAnchor))
        constraints.append(bottomLabelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2))
        constraints.append(bottomLabelStackView.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor))
        
        topContentView.addSubview(topLabelStackView)
        topLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(topLabelStackView.leftAnchor.constraint(equalTo: topContentView.leftAnchor))
        constraints.append(topLabelStackView.widthAnchor.constraint(equalTo: bottomLabelStackView.widthAnchor, multiplier: 0.8))
        constraints.append(topLabelStackView.bottomAnchor.constraint(equalTo: bottomLabelStackView.topAnchor))
        constraints.append(topLabelStackView.heightAnchor.constraint(equalToConstant: Lets.liftCellTableHeaderHeight / 2))
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension WorkoutLiftCell: SetCellDelegate {
    func cellShouldJumpToNextTextField(_ cell: UITableViewCell) {
        let theInnerIndexPath = innerIndexPath(forInner: cell)!
        let newInnerIndexPath = IndexPath(row: theInnerIndexPath.row + 1, section: theInnerIndexPath.section)
        let newInnerCell = innerCellForRow(atInner: newInnerIndexPath) as? WorkoutSetCell ?? liftCellDelegate.cellShouldJumpToNewSet(for: self, atInner: newInnerIndexPath) as! WorkoutSetCell
        newInnerCell.completedWeightTextField.placeholder = "0"
        newInnerCell.completedRepsTextField.placeholder = "0"
        newInnerCell.targetWeightTextField.becomeFirstResponder()
     }
    
    func setCell(_ setCell: SetCell, didTap button: UIButton, for object: ManagedObject) {
        delegate?.cell?(self, didTap: button, for: object, or: nil)
    }
}


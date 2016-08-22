import UIKit
import CoreData

extension Lift: DataProvider {
    
    func object(at indexPath: IndexPath) -> LSet {
        guard let sets = sets else { fatalError() }
        let lset = sets.object(at: indexPath.row)
        print(lset)
        return sets.object(at: indexPath.row) as! LSet
    }
    func numberOfItems(inSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        if let sets = sets {
            return sets.count
        } else {
            return 0
        }
    }
    func numberOfSections() -> Int {
        return 2
    }
    func insert(object: LSet) -> IndexPath {
        managedObjectContext?.performAndWait {
            self.addToSets(object)
            object.targetReps = 6
            object.targetWeight = 225
            do {
                try self.managedObjectContext?.save()
            } catch {
                print("===============ERROR==============")
                print(error)
            }
        }
        let row = sets?.count ?? 1
        return IndexPath(row: row - 1, section: 0)
    }
    func remove(object: LSet) {
        managedObjectContext?.performAndWait {
            self.removeFromSets(object)
            do {
                try self.managedObjectContext?.save()
            } catch {
                print("===============ERROR==============")
                print(error)
            }
        }
    }
}

class LiftCell: WorkoutAndRoutineCell<Lift> {
    var topLabelStackView: UIStackView!
    var bottomLabelStackView: UIStackView!
}

extension LiftCell: ConfigurableCell {
    
    func configureForObject(object: Lift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        setupTableLabels()
    }
    
    func setupTableLabels() {
        let twLabel = UILabel()
        twLabel.text = "Weight"
        let trLabel = UILabel()
        trLabel.text = "Reps"
        let cwLabel = UILabel()
        cwLabel.text = "Weight"
        let crLabel = UILabel()
        crLabel.text = "Reps"
        let statusLabel = UILabel()
        statusLabel.text = "Status"
        let bottomLabels = [twLabel,trLabel,cwLabel,crLabel, statusLabel]
        for label in bottomLabels {
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = Theme.Fonts.tableHeaderFont.font
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.layer.borderWidth = 1.0
        }
        bottomLabelStackView = UIStackView(arrangedSubviews: bottomLabels)
        bottomLabelStackView.spacing = 0
        bottomLabelStackView.axis = .horizontal
        bottomLabelStackView.distribution = .fillEqually

        let targetLabel = UILabel()
        targetLabel.text = "Target"
        let completedLabel = UILabel()
        completedLabel.text = "Completed"
        let topLabels = [targetLabel,completedLabel]
        for label in topLabels {
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = Theme.Fonts.tableHeaderFont.font
//            label.layer.borderColor = UIColor.darkGray.cgColor
//            label.layer.borderWidth = 1.0
        }
        topLabelStackView = UIStackView(arrangedSubviews: topLabels)
        topLabelStackView.spacing = 0
        topLabelStackView.axis = .horizontal
        topLabelStackView.distribution = .fillEqually
        
        
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

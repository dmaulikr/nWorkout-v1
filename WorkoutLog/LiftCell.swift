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
                print(error)
            }
        }
    }
}

class LiftCell: WorkoutAndRoutineCell<Lift> {
    var labelStackView: UIStackView!
}

extension LiftCell: ConfigurableCell {
    
    func configureForObject(object: Lift, at indexPath: IndexPath) {
        nameLabel.text = object.name
        //backgroundColor = nil
        setupTableLabels()
    }
    
    func setupTableLabels() {
        let twLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        twLabel.text = "Target Weight"
        let trLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        trLabel.text = "Target Reps"
        let cwLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        cwLabel.text = "Completed Weight"
        let crLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        crLabel.text = "Completed Reps"
        let statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        statusLabel.text = "Status"
        let labels = [twLabel,trLabel,cwLabel,crLabel, statusLabel]
        for label in labels {
            label.textAlignment = .center
            label.numberOfLines = 0
        }
        labelStackView = UIStackView(arrangedSubviews: labels)
        labelStackView.spacing = 10
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        contentView.addSubview(labelStackView)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8 * 2).isActive = true
        labelStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8 * 2).isActive = true
        labelStackView.heightAnchor.constraint(equalToConstant: CGFloat(Lets.subTVCellSize)).isActive = true
        labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
    }
}

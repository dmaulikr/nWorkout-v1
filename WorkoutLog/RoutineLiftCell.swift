import UIKit
import CoreData

extension RoutineLift: DataProvider {
    
    func object(at: IndexPath) -> RoutineSet {
        return sets!.object(at: at.row) as! RoutineSet
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
}

class RoutineLiftCell: TableViewCellWithTableView {
    var nameLabel: UILabel
    
    required init(delegateAndDataSource: TableViewCellWithTableViewDelegate & TableViewCellWithTableViewDataSource,
                  indexPath: IndexPath) {
        
        let nameFrame = CGRect(x: 0, y: 0, width: Lets.liftCellNameLabelWidth, height: Lets.liftCellNameLabelHeight)
        nameLabel = UILabel(frame: nameFrame)
        
        super.init(delegateAndDataSource: delegateAndDataSource,
                   indexPath: indexPath)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoutineLiftCell: UITableViewDelegate { }



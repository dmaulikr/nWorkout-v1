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
}

class LiftCell: TableViewCellWithTableView {
    
    var nameLabel: UILabel
    
    required init(delegateAndDataSource: TableViewCellWithTableViewDelegateAndDataSource,
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

extension LiftCell: ConfigurableCell {
    func configureForObject(object: Lift, at indexPath: IndexPath) {
        nameLabel.text = object.name
    }
}

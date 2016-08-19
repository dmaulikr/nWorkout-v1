import UIKit
import CoreData



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



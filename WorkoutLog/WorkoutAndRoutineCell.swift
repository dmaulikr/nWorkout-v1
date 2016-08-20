import UIKit
import CoreData

class WorkoutAndRoutineCell<Type: NSManagedObject>: TableViewCellWithTableView {
    var nameLabel: UILabel
    required init(delegateAndDataSource: AnyTVCWTVDADS<Int>, indexPath: IndexPath) {
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 35))
        super.init(delegateAndDataSource: delegateAndDataSource, indexPath: indexPath)
        contentView.addSubview(nameLabel)
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

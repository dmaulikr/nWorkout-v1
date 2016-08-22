import UIKit
import CoreData

class WorkoutAndRoutineCell<Type: NSManagedObject>: TableViewCellWithTableView {
    var nameLabel: UILabel
    required init(delegateAndDataSource: AnyTVCWTVDADS<Int>, indexPath: IndexPath) {
        nameLabel = UILabel()
        super.init(delegateAndDataSource: delegateAndDataSource, indexPath: indexPath)
        contentView.addSubview(nameLabel)
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Lets.liftCellNameLabelHeight).isActive = true
        
        nameLabel.font = Theme.Fonts.titleFont.font
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

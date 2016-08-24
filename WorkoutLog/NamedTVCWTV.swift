import UIKit
import CoreData

class NamedTVCWTV<Type: ManagedObject>: TableViewCellWithTableView {
    var nameLabel: UILabel
    required init(delegateAndDataSource: TableViewCellWithTableViewDelegateAndDataSource, indexPath: IndexPath) {
        
        nameLabel = Label(cellNameLabelStyleWith: "")
        
        super.init(delegateAndDataSource: delegateAndDataSource, indexPath: indexPath)
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Lets.buffer).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Lets.buffer).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Lets.liftCellNameLabelHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


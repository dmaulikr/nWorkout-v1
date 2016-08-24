import UIKit
import CoreData

class NamedTVCWTV<Type: ManagedObject>: TableViewCellWithTableView {
    var nameLabel: UILabel
    required init(delegateAndDataSource: TableViewCellWithTableViewDelegateAndDataSource, indexPath: IndexPath) {
        
        nameLabel = Label(cellNameLabelStyleWith: "")
        
        super.init(delegateAndDataSource: delegateAndDataSource, indexPath: indexPath)
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer))
        constraints.append(nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Lets.buffer))
        constraints.append(nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Lets.buffer))
        constraints.append(nameLabel.heightAnchor.constraint(equalToConstant: Lets.liftCellNameLabelHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureForObject(object: Type, at indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}

extension NamedTVCWTV: ConfigurableCell {
    
}

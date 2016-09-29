import UIKit
import CoreData

class NamedTVCWTV<Type: ManagedObject>: TableViewCellWithTableView {
    
    var nameLabel: UILabel
    var noteButton: UIButton
    
    required init(delegateAndDataSource: TableViewCellWithTableViewDelegateAndDataSource, indexPath: IndexPath) {
        
        nameLabel = Label(cellNameLabelStyleWith: "")
        noteButton = UIButton(type: .roundedRect)
        noteButton.setTitle("note", for: UIControlState())
        noteButton.setTitleColor(.darkGray, for: UIControlState())
        noteButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        noteButton.layer.borderWidth = 1
        noteButton.layer.borderColor = UIColor.darkGray.cgColor
        noteButton.layer.cornerRadius = 5
                
        super.init(delegateAndDataSource: delegateAndDataSource, indexPath: indexPath)
        
        noteButton.addTarget(self, action: #selector(noteButtonTapped(button:)), for: .touchUpInside)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(noteButton)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        noteButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Lets.buffer))
        constraints.append(nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Lets.buffer))
        constraints.append(nameLabel.rightAnchor.constraint(equalTo: noteButton.leftAnchor, constant: Lets.buffer))
        constraints.append(nameLabel.heightAnchor.constraint(equalToConstant: Lets.liftCellNameLabelHeight))
        constraints.append(noteButton.heightAnchor.constraint(equalToConstant: Lets.liftCellNameLabelHeight))
        constraints.append(noteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Lets.buffer))
        noteButton.setContentHuggingPriority(.abs(999), for: .horizontal)
        nameLabel.setContentHuggingPriority(.abs(998), for: .horizontal)
        constraints.append(noteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Lets.buffer))
        NSLayoutConstraint.activate(constraints)
    }
    
    func noteButtonTapped(button: UIButton) {
        delegate?.cell(self, didTap: button)
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

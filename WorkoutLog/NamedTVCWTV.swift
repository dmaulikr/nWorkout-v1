import UIKit
import CoreData

class NamedTVCWTV<Type: ManagedObject>: TableViewCellWithTableView {
    
    var nameLabel: UILabel!
    var noteButton: UIButton!
    
    func noteButtonTapped(button: UIButton) {
        delegate?.cell?(self, didTap: button)
    }

    func configureForObject(object: Type, at indexPath: IndexPath) {
        self.outerIndexPath = indexPath
        setTopContentView()
    }
    
    override var topContentViewHeight: CGFloat{ return Lets.innerTableHeaderViewHeight }
    func setTopContentView() {
        nameLabel = Label(cellNameLabelStyleWith: "")
        nameLabel.numberOfLines = 0
        noteButton = UIButton(type: .roundedRect)
        noteButton.setTitle("note", for: UIControlState())
        noteButton.setTitleColor(.darkGray, for: UIControlState())
        noteButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        noteButton.layer.borderWidth = 1
        noteButton.layer.borderColor = UIColor.darkGray.cgColor
        noteButton.layer.cornerRadius = 8
        
        topContentView.frame = CGRect(x: 0, y: 0, width: 0, height: topContentViewHeight)
        topContentViewHeightConstraint.constant = Lets.innerTableHeaderViewHeight
        noteButton.addTarget(self, action: #selector(noteButtonTapped(button:)), for: .touchUpInside)
        
        topContentView.addSubview(nameLabel)
        topContentView.addSubview(noteButton)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        noteButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(nameLabel.leftAnchor.constraint(equalTo: topContentView.leftAnchor))
        constraints.append(nameLabel.topAnchor.constraint(equalTo: topContentView.topAnchor))
        constraints.append(nameLabel.rightAnchor.constraint(equalTo: noteButton.leftAnchor))
        constraints.append(noteButton.rightAnchor.constraint(equalTo: topContentView.rightAnchor))
        noteButton.setContentHuggingPriority(.abs(999), for: .horizontal)
        nameLabel.setContentHuggingPriority(.abs(998), for: .horizontal)
        constraints.append(noteButton.topAnchor.constraint(equalTo: topContentView.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

extension NamedTVCWTV: ConfigurableCell {
    
}

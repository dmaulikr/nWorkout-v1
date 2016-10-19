import UIKit
import CoreData

class NamedTVCWTV<Type: ManagedObject>: TableViewCellWithTableView, ConfigurableCell {
    
    var nameLabel: UILabel!
    var nameTextField: UITextField!
    var nameStackView: UIStackView!
    var noteButton: UIButton!
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func noteButtonTapped(button: UIButton) {
        delegate?.cell?(self, didTap: button, for: nil, or: nil)
    }

    func configureForObject(object: Type, at indexPath: IndexPath) {
        self.outerIndexPath = indexPath
        setTopContentView()
    }
    
    func setNameStackView() {
        nameLabel = UILabel(cellNameLabelStyleWith: "")
        nameLabel.numberOfLines = 0
        nameStackView = UIStackView(arrangedSubviews: [nameLabel], axis: .horizontal, spacing: 0, distribution: .fill)
    }
    
    override var topContentViewHeight: CGFloat { return Lets.innerTableHeaderViewHeight }
    func setTopContentView() {
        setNameStackView()
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

        topContentView.addSubview(nameStackView)
        topContentView.addSubview(noteButton)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        noteButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(nameStackView.leftAnchor.constraint(equalTo: topContentView.leftAnchor))
        constraints.append(nameStackView.topAnchor.constraint(equalTo: topContentView.topAnchor))
        constraints.append(nameStackView.rightAnchor.constraint(equalTo: noteButton.leftAnchor))
        constraints.append(noteButton.rightAnchor.constraint(equalTo: topContentView.rightAnchor))
        noteButton.setContentHuggingPriority(.abs(999), for: .horizontal)
        nameStackView.setContentHuggingPriority(.abs(998), for: .horizontal)
        constraints.append(noteButton.topAnchor.constraint(equalTo: topContentView.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

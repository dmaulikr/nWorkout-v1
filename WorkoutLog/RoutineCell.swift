import UIKit

class RoutineCell: NamedTVCWTV<Routine> {
    
    override func setNameStackView() {
        nameTextField = UITextField()
        nameStackView = StackView(arrangedSubviews: [nameTextField], axis: .horizontal, spacing: 0, distribution: .fill)
    }
    
    override func setName(_ name: String) {
        nameTextField.text = name
    }
    
    override func configureForObject(object: Routine, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        setName(object.name!)
    }
}


import UIKit

class RoutineCell: NamedTVCWTV<Routine>, UITextFieldDelegate {
    
    var routineCellDelegate: RoutineCellDelegate!
    
    override func setNameStackView() {
        nameTextField = UITextField()
        nameStackView = UIStackView(arrangedSubviews: [nameTextField], axis: .horizontal, spacing: 0, distribution: .fill)
    }
    
    override func setName(_ name: String) {
        nameTextField.text = name
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            routineCellDelegate.userInputEmptyName()
            return false
        }
        textField.resignFirstResponder()
        routineCellDelegate.routineCell(self, nameChangedTo: textField.text!)
        return true
    }
    
    override func configureForObject(object: Routine, at indexPath: IndexPath) {
        super.configureForObject(object: object, at: indexPath)
        setName(object.name!)
    }
}

protocol RoutineCellDelegate {
    func routineCell(_ routineCell: RoutineCell, nameChangedTo name: String)
    func userInputEmptyName()
}

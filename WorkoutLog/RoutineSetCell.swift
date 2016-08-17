import UIKit

extension RoutineSetCell: ConfigurableCell {
    typealias DataSource = RoutineSet
    func configureForObject(object: RoutineSet, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            textLabel?.text = "Add set..."
            weightTextField.isHidden = true
            repsTextField.isHidden = true
        } else {
            textLabel?.text = ""
            weightTextField.isHidden = false
            repsTextField.isHidden = false

            set = object
        }
    }
}

class RoutineSetCell: UITableViewCell, KeyboardDelegate {
    
    var set: RoutineSet! {
        didSet {
            reps = Int(set.reps)
            weight = Int(set.weight)
            
            keyboardView.delegate = self
            weightTextField.inputView = keyboardView
            repsTextField.inputView = keyboardView
        }
    }
    
    var keyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: (UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)! / 3))
    var currentlyEditing: UITextField?
    
    func keyWasTapped(character: String) {
        currentlyEditing?.text = currentlyEditing!.text! + character
    }
    func backspaceWasTapped() {
        currentlyEditing?.deleteBackward()
    }
    func hideWasTapped() {
        endEditing(true)
    }
    func nextWasTapped() {
        switch currentlyEditing! {
        case weightTextField:
            currentlyEditing = repsTextField
        case repsTextField:
            currentlyEditing = nil
            endEditing(true)
        default:
            break
        }
        currentlyEditing?.becomeFirstResponder()
    }
    
    var weightTextField: UITextField! { didSet { weightTextField.delegate = self } }
    var weight: Int {
        get {
            return Int(set.weight)
        }
        set {
            set.managedObjectContext?.perform {
                self.set.weight = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            weightTextField.text = "\(newValue)"
        }
    }
    var repsTextField: UITextField! { didSet { repsTextField.delegate = self } }
    var reps: Int {
        get {
            return Int(set.reps)
        }
        set {
            set.managedObjectContext?.perform {
                self.set.reps = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            repsTextField.text = "\(newValue)"
        }
    }
}


extension RoutineSetCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentlyEditing = textField
        if textField.text! == "0" {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if currentlyEditing === textField {
            currentlyEditing = nil
        }
        
        let value = Int(textField.text!)!
        switch textField {
        case self.weightTextField:
            self.weight = value
        case self.repsTextField:
            self.reps = value
        default:
            break
        }

    }
}

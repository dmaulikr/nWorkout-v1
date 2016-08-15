import UIKit

extension SetCell: ConfigurableCell {
    typealias DataSource = LSet
    func configureForObject(object: LSet, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            textLabel?.text = "Add set..."
            targetWeightTextField.isHidden = true
            targetRepsTextField.isHidden = true
            completedWeightTextField.isHidden = true
            completedRepsTextField.isHidden = true
            statusButton.isHidden = true
        } else {
            textLabel?.text = ""
            targetWeightTextField.isHidden = false
            targetRepsTextField.isHidden = false
            completedWeightTextField.isHidden = false
            completedRepsTextField.isHidden = false
            statusButton.isHidden = false

            set = object
        }
    }
}

class SetCell: UITableViewCell, KeyboardDelegate {
    
    var set: LSet! {
        didSet {
            targetReps = Int(set.targetReps)
            targetWeight = Int(set.targetWeight)
            completedReps = Int(set.completedReps)
            completedWeight = Int(set.completedWeight)
            statusButton.status = set.setStatus
            
            keyboardView.delegate = self
            targetWeightTextField.inputView = keyboardView
            targetRepsTextField.inputView = keyboardView
            completedWeightTextField.inputView = keyboardView
            completedRepsTextField.inputView = keyboardView
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
        case targetWeightTextField:
            currentlyEditing = targetRepsTextField
        case targetRepsTextField:
            currentlyEditing = completedWeightTextField
        case completedWeightTextField:
            currentlyEditing = completedRepsTextField
        case completedRepsTextField:
            currentlyEditing = nil
            endEditing(true)
        default:
            break
        }
        currentlyEditing?.becomeFirstResponder()
    }
    
    @IBOutlet weak var targetWeightTextField: UITextField! { didSet { targetWeightTextField.delegate = self } }
    var targetWeight: Int {
        get {
            return Int(set.targetWeight)
        }
        set {
            set.managedObjectContext?.perform {
                self.set.targetWeight = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            targetWeightTextField.text = "\(newValue)"
        }
    }
    @IBOutlet weak var targetRepsTextField: UITextField! { didSet { targetRepsTextField.delegate = self } }
    var targetReps: Int {
        get {
            return Int(set.targetReps)
        }
        set {
            set.managedObjectContext?.perform {
                self.set.targetReps = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            targetRepsTextField.text = "\(newValue)"
        }
    }
    
    @IBOutlet weak var completedWeightTextField: UITextField! { didSet { completedWeightTextField.delegate = self } }
    var completedWeight: Int {
        get {
            return Int(set.completedWeight)
        }
        set {
            set.managedObjectContext?.performAndWait {
                self.set.completedWeight = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            completedWeightTextField.text = "\(newValue)"
        }
    }
    @IBOutlet weak var completedRepsTextField: UITextField! { didSet { completedRepsTextField.delegate = self } }
    var completedReps: Int {
        get {
            return Int(set.completedReps)
        }
        set {
            set.managedObjectContext?.performAndWait {
                self.set.completedReps = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            completedRepsTextField.text = "\(newValue)"
        }
    }
    
    @IBOutlet weak var statusButton: SetStatusButton!
    
    @IBAction func statusButtonPushed(_ sender: SetStatusButton) {
        sender.status = sender.status.next()
        set.managedObjectContext?.perform {
            self.set.setStatus = sender.status
        }
        switch sender.status {
        case .incomplete:
            completedWeight = 0
            completedReps = 0
        case .done:
            completedWeight = targetWeight
            completedReps = targetReps
        case .fail:
            completedWeight = 0
            completedReps = 0
        case .skip:
            completedWeight = 0
            completedReps = 0
        }
    }
    
}

enum SetStatus: String {
    case incomplete = "Incomplete"
    case done = "Done"
    case fail = "Fail"
    case skip = "Skip"
    
    func next() -> SetStatus {
        switch self {
        case .incomplete: return .done
        case .done: return .fail
        case .fail: return .skip
        case .skip: return .incomplete
        }
    }
}

class SetStatusButton: UIButton {
    var status: SetStatus = .incomplete {
        didSet {
            setTitle(status.rawValue, for: UIControlState())
        }
    }
}


extension SetCell: UITextFieldDelegate {
    
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
        case self.targetWeightTextField:
            self.targetWeight = value
        case self.targetRepsTextField:
            self.targetReps = value
        case self.completedWeightTextField:
            self.completedWeight = value
        case self.completedRepsTextField:
            self.completedReps = value
        default:
            break
        }
        if self.completedWeight == self.targetWeight && self.completedReps == self.targetReps {
            self.statusButton.status = .done
        } else {
            self.statusButton.status = .fail
        }
    }
}

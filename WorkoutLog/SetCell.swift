import UIKit

class SetCell: UITableViewCell {
    
    var set: LSet!
    
    @IBOutlet weak var targetWeightTextField: UITextField! { didSet { targetWeightTextField.delegate = self } }
    @IBOutlet weak var targetRepsTextField: UITextField! { didSet { targetRepsTextField.delegate = self } }
    
    @IBOutlet weak var completedWeightTextField: UITextField! { didSet { completedWeightTextField.delegate = self } }
    @IBOutlet weak var completedRepsTextField: UITextField! { didSet { completedRepsTextField.delegate = self } }

    
    
    @IBAction func statusButtonPushed(_ sender: SetStatusButton) {
        sender.status = sender.status.next()
        switch sender.status {
        case .incomplete:
            completedWeightTextField.text = "\(0)"
            completedRepsTextField.text = "\(0)"
        case .done:
            completedWeightTextField.text = targetWeightTextField.text
            completedRepsTextField.text = targetRepsTextField.text
        case .fail:
            completedWeightTextField.text = "\(0)"
            completedRepsTextField.text = "\(0)"
        case .skip:
            completedWeightTextField.text = "\(0)"
            completedRepsTextField.text = "\(0)"
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        set.managedObjectContext?.perform {
            if textField === self.targetWeightTextField {
                self.set.weight = Int16(textField.text!)!
            } else if textField === self.targetRepsTextField {
                self.set.targetReps = Int16(textField.text!)!
            }
            try! self.set.managedObjectContext?.save()
        }
    }
}

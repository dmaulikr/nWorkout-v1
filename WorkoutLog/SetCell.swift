import UIKit


extension SetCell: ConfigurableCell {
    typealias DataSource = LSet
    func configureForObject(object: LSet, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            textLabel?.text = Lets.addSetText
            textFields.forEach { $0.isHidden = true }
            statusButton.isHidden = true
        } else {
            textLabel?.text = ""
            textFields.forEach { $0.isHidden = false }
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
            textFields.forEach { $0.inputView = keyboardView }
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        targetWeightTextField = UITextField()
        targetRepsTextField = UITextField()
        completedWeightTextField = UITextField()
        completedRepsTextField = UITextField()
        textFields += [targetWeightTextField, targetRepsTextField, completedWeightTextField, completedRepsTextField]
        statusButton = SetStatusButton(type: .system)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Configure TextFields
        for textField in textFields {
            textField.borderStyle = .line
            textField.textAlignment = .center
            textField.delegate = self
        }
        
        //Configure Button
        let views: [UIView] = textFields + [statusButton]
        statusButton.addTarget(self, action: #selector(statusButtonPushed(_:)), for: .touchUpInside)
        
        //Configure StackView
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8.0).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textFields = [UITextField]()
    var targetWeightTextField: UITextField
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
    var targetRepsTextField: UITextField
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
    
    var completedWeightTextField: UITextField
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
    var completedRepsTextField: UITextField
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
    
    var statusButton: SetStatusButton
    
    func statusButtonPushed(_ button: SetStatusButton) {
        button.status = button.status.next()
        set.managedObjectContext?.perform {
            self.set.setStatus = button.status
        }
        switch button.status {
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
    
    var keyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: Double((UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)!) * Lets.keyboardToViewRatio))
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
        
        let value = Int(textField.text!) ?? 0
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
        } else if completedWeightTextField == textField || completedRepsTextField == textField {
            self.statusButton.status = .fail
        }
    }
}

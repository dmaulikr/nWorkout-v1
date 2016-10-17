import UIKit

protocol SetCellDelegate: class {
    func cellShouldJumpToNextTextField(_ cell: InnerTableViewCell)
}

protocol SetCell {
    var textFields: [UITextField] { get }
}

extension WorkoutSetCell: ConfigurableCell, SetCell {
    typealias DataSource = WorkoutSet
    func configureForObject(object: WorkoutSet, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            textLabel?.text = Lets.addSetText
            textFields.forEach { $0.isHidden = true }
            statusButton.isHidden = true
        } else {
            textLabel?.text = ""
            textFields.forEach {
                $0.isHidden = false
                $0.placeholder = "0"
            }
            statusButton.isHidden = false
            
            set = object
        }
    }
    
    
}

class WorkoutSetCell: InnerTableViewCell, KeyboardDelegate {
    var delegate: SetCellDelegate?
    var set: WorkoutSet! {
        didSet {
            targetReps = Int(set.targetReps)
            targetWeight = Int(set.targetWeight)
            completedReps = Int(set.completedReps)
            completedWeight = Int(set.completedWeight)
            statusButton.status = set.setStatus
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
            textField.inputView = keyboardView
            textField.placeholder = "0"
        }
        
        keyboardView.delegate = self
        
        //Configure Button
        let views: [UIView] = textFields + [statusButton]
        statusButton.addTarget(self, action: #selector(statusButtonPushed(_:)), for: .touchUpInside)
        
        //Configure StackView
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = stackView.constrainAnchors(to: contentView, constant: 0)
        NSLayoutConstraint.activate(constraints)
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
            if newValue > 0 {
                targetWeightTextField.text = "\(newValue)"
            }
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
            if newValue > 0 {
                targetRepsTextField.text = "\(newValue)"
            }
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
            if newValue > 0 {
                completedWeightTextField.text = "\(newValue)"
            }
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
            if newValue > 0 {
                completedRepsTextField.text = "\(newValue)"
            }
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
    
    let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: Double((UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)!) * Lets.keyboardToViewRatio))
    var currentlyEditing: UITextField?
}

extension WorkoutSetCell {
    
    func keyWasTapped(character: String) {
        currentlyEditing?.text = currentlyEditing!.text! + character
        textFieldDidChange(textField: currentlyEditing!)
    }
    func backspaceWasTapped() {
        currentlyEditing?.deleteBackward()
        textFieldDidChange(textField: currentlyEditing!)
    }
    func textFieldDidChange(textField: UITextField) {
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
        default: fatalError()
        }
    }
    
    func hideWasTapped() {
        _ = endEditing(true)
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        replaceValueWithPlaceholder()
        textFields.forEach { textField in
            if (textField.text == nil || textField.text == ""), let ph = textField.placeholder, let phValue = Int(ph), phValue > 0 {
                switch textField {
                case targetWeightTextField: targetWeight = phValue
                case targetRepsTextField: targetReps = phValue
                case completedWeightTextField: completedWeight = phValue
                case completedRepsTextField: completedReps = phValue
                default: fatalError()
                }
            }
        }
        return super.endEditing(force)
    }
    func replaceValueWithPlaceholder() {
        if currentlyEditing?.text == nil || currentlyEditing!.text == "", let ph = currentlyEditing?.placeholder, let value = Int(ph) {
            switch currentlyEditing! {
            case targetWeightTextField:
                targetWeight = value
            case targetRepsTextField:
                targetReps = value
            case completedWeightTextField:
                completedWeight = value
            case completedRepsTextField:
                completedReps = value
            default: fatalError()
            }
        }
    }
    func nextWasTapped() {
        replaceValueWithPlaceholder()
        
        switch currentlyEditing! {
        case targetWeightTextField:
            currentlyEditing = targetRepsTextField
        case targetRepsTextField:
            currentlyEditing = completedWeightTextField
        case completedWeightTextField:
            currentlyEditing = completedRepsTextField
        case completedRepsTextField:
            currentlyEditing = nil
            delegate?.cellShouldJumpToNextTextField(self)
        default:
            break
        }
        currentlyEditing?.becomeFirstResponder()
    }
}

enum SetStatus: String {
    case incomplete = " "
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
    let attributes = [
        NSFontAttributeName : Theme.Fonts.title,
        NSForegroundColorAttributeName : UIColor.black
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1.0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var status: SetStatus = .incomplete {
        didSet {
            let attributedString = NSAttributedString(string: status.rawValue, attributes: attributes)
            setAttributedTitle(attributedString, for: UIControlState())
            if status == .incomplete {
                
            }
        }
    }
}


extension WorkoutSetCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentlyEditing = textField
        guard let text = textField.text, let value = Int(text), value > 0 else { return }
        textField.placeholder = text
        textField.text = nil
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
        } else if completedWeight == 0 || completedReps == 0 {
            return
        } else if completedWeightTextField == textField || completedRepsTextField == textField {
            self.statusButton.status = .fail
        }
    }
}

import UIKit

extension RoutineSetCell: ConfigurableCell {
    typealias DataSource = RoutineSet
    func configureForObject(object: RoutineSet, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            textLabel?.text = Lets.addSetText
            textFields.forEach { $0.isHidden = true }
            
        } else {
            textLabel?.text = nil
            textFields.forEach {
                $0.isHidden = false
                $0.layer.borderColor = UIColor.darkGray.cgColor
                $0.layer.borderWidth = 1.0
                $0.placeholder = "0"
            }
            
            set = object
        }
        selectionStyle = .none
    }
}

class RoutineSetCell: UITableViewCell, KeyboardDelegate, SetCell {
    var delegate: SetCellDelegate!
    var set: RoutineSet! {
        didSet {
            reps = Int(set.reps)
            weight = Int(set.weight)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        weightTextField = UITextField()
        repsTextField = UITextField()
        textFields += [weightTextField, repsTextField]
        
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
        
        //Configure StackView
        let stackView = UIStackView(arrangedSubviews: textFields)
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
    var weightTextField: UITextField
    var weight: Int {
        get {
            return Int(set.weight)
        }
        set {
            set.managedObjectContext?.perform {
                self.set.weight = Int16(newValue)
                do {
                    try self.set.managedObjectContext?.save()
                } catch {
                    print(error: error)
                }
            }
            if newValue > 0 {
                weightTextField.text = "\(newValue)"
            }
        }
    }
    var repsTextField: UITextField
    var reps: Int {
        get {
            return Int(set.reps)
        }
        set {
            set.managedObjectContext?.perform {
                self.set.reps = Int16(newValue)
                do {
                    try self.set.managedObjectContext?.save()
                } catch {
                    print(error: error)
                }
            }
            if newValue > 0 {
                repsTextField.text = "\(newValue)"
            }
        }
    }
    // MARK: KeyboardView
    let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: (UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)! / 3))
    var currentlyEditing: UITextField?
}

extension RoutineSetCell {
    
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
        case self.weightTextField:
            self.weight = value
        case self.repsTextField:
            self.reps = value
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
                case weightTextField: weight = phValue
                case repsTextField: reps = phValue
                default: fatalError()
                }
            }
        }
        return super.endEditing(force)
    }
    func replaceValueWithPlaceholder() {
        if currentlyEditing?.text == nil || currentlyEditing!.text == "", let ph = currentlyEditing?.placeholder, let value = Int(ph) {
            switch currentlyEditing! {
            case weightTextField:
                weight = value
            case repsTextField:
                reps = value
            default: fatalError()
            }
        }
    }
    func nextWasTapped() {
        replaceValueWithPlaceholder()
        
        switch currentlyEditing! {
        case weightTextField:
            currentlyEditing = repsTextField
        case repsTextField:
            delegate?.cellShouldJumpToNextTextField(self)
        default: fatalError()
        }
        currentlyEditing?.becomeFirstResponder()
    }
    
}

extension RoutineSetCell: UITextFieldDelegate {
    
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
        case self.weightTextField:
            self.weight = value
        case self.repsTextField:
            self.reps = value
        default:
            break
        }
        
    }
}

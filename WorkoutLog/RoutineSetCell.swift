import UIKit

extension RoutineSetCell: ConfigurableCell {
    typealias DataSource = RoutineSet
    func configureForObject(object: RoutineSet, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            textLabel?.text = "Add set..."
            textFields.forEach { $0.isHidden = true }
        } else {
            textLabel?.text = ""
            textFields.forEach { $0.isHidden = false }
            
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
            textFields.forEach { $0.inputView = keyboardView }
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
        }
        
        //Configure StackView
        let stackView = UIStackView(arrangedSubviews: textFields)
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
    var weightTextField: UITextField
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
    var repsTextField: UITextField
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
    // MARK: KeyboardView
    var keyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: (UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)! / 3))
    var currentlyEditing: UITextField?
}

extension RoutineSetCell {
    
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

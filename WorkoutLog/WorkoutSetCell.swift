import UIKit

protocol SetCellDelegate: class {
    func cellShouldJumpToNextTextField(_ cell: InnerTableViewCell)
    func setCell(_ setCell: SetCell, didTap button: UIButton, for object: ManagedObject)
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
            doneButton.isHidden = true
        } else {
            textLabel?.text = ""
            textFields.forEach {
                $0.isHidden = false
                $0.placeholder = "0"
            }
            doneButton.isHidden = false
            doneButton.setStandardBorder()
            set = object
        }
        selectionStyle = .none
    }
}

class WorkoutSetCell: InnerTableViewCell, KeyboardDelegate {
    var delegate: SetCellDelegate?
    var set: WorkoutSet! {
        didSet {
            print(set.targetWeight, set.targetReps, set.completedWeight, set.completedReps)
            changeTargetWeight(Int(set.targetWeight))
            changeTargetReps(Int(set.targetReps))
            changeCompletedWeight(Int(set.completedWeight))
            changeCompletedReps(Int(set.completedReps))
            changeIsDone(set.setStatus == .done)
            changeHasFailed(set.setStatus == .fail)
        }
    }
    let failureStackView: UIStackView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        textFields += [targetWeightTextField, targetRepsTextField, completedWeightTextField, completedRepsTextField]
        
        let completedWeightLabel = UILabel(text: "weight", textAlignment: .center, numberOfLines: 1, font: Theme.Fonts.tableHeader, borderColor: UIColor.darkGray.cgColor, borderWidth: 1)
        let completedRepsLabel = UILabel(text: "reps", textAlignment: .center, numberOfLines: 1, font: Theme.Fonts.tableHeader, borderColor: UIColor.darkGray.cgColor, borderWidth: 1)
        let weightStackView = StackView(arrangedSubviews: [completedWeightLabel,completedWeightTextField], axis: .vertical, spacing: 0, distribution: .fill)
        let repsStackView = StackView(arrangedSubviews: [completedRepsLabel,completedRepsTextField], axis: .vertical, spacing: 0, distribution: .fill)
        failureStackView = StackView(arrangedSubviews: [weightStackView,repsStackView], axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.borderWidth = 0
        
        //Configure TextFields
        textFields.forEach { textField in
            textField.borderStyle = .line
            textField.textAlignment = .center
            textField.delegate = self
            textField.inputView = keyboardView
            textField.placeholder = "0"
        }
        
        keyboardView.delegate = self
        
        let views: [UIView] = [targetWeightTextField,targetRepsTextField,doneButton,failureStackView]
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(noteButton)
        noteButton.translatesAutoresizingMaskIntoConstraints = false
        noteButton.setContentHuggingPriority(1000, for: .horizontal)
        noteButton.actionClosure = { [unowned self] button in
            print("note button tapped")
            self.delegate?.setCell(self, didTap: self.noteButton, for: self.set)
        }
        contentView.addSubview(failButton)
        failButton.translatesAutoresizingMaskIntoConstraints = false
        failButton.setContentHuggingPriority(1000, for: .horizontal)
        failButton.actionClosure = { [unowned self] button in
            self.hasFailed = !self.hasFailed
        }
        
        doneButton.actionClosure = { [unowned self] button in
            self.isDone = !self.isDone
        }
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: failButton.leftAnchor),
            failButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            failButton.rightAnchor.constraint(equalTo: noteButton.leftAnchor),
            noteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            noteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }
    
    
    let noteButton = Button.buttonForSetCell(title: "n")
    let failButton = Button.buttonForSetCell(title: "f")
    
    var textFields = [UITextField]()
    
    let targetWeightTextField = UITextField()
    var targetWeight: Int {
        get { return Int(set.targetWeight) }
        set {
            set.managedObjectContext?.perform {
                self.set.targetWeight = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            changeTargetWeight(newValue)
        }
    }
    func changeTargetWeight(_ targetWeight: Int) {
        targetWeightTextField.text = "\(targetWeight)"
    }
    let targetRepsTextField = UITextField()
    var targetReps: Int {
        get { return Int(set.targetReps) }
        set {
            set.managedObjectContext?.perform {
                self.set.targetReps = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            changeTargetReps(newValue)
        }
    }
    func changeTargetReps(_ targetReps: Int) {
        targetRepsTextField.text = "\(targetReps)"
    }
    let completedWeightTextField = UITextField()
    var completedWeight: Int {
        get { return Int(set.completedWeight) }
        set {
            set.managedObjectContext?.performAndWait {
                self.set.completedWeight = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            changeCompletedWeight(newValue)
        }
    }
    func changeCompletedWeight(_ completedWeight: Int) {
        completedWeightTextField.text = "\(completedWeight)"
    }
    let completedRepsTextField = UITextField()
    var completedReps: Int {
        get { return Int(set.completedReps) }
        set {
            set.managedObjectContext?.perform {
                self.set.completedReps = Int16(newValue)
                try! self.set.managedObjectContext?.save()
            }
            changeCompletedReps(newValue)
        }
    }
    func changeCompletedReps(_ completedReps: Int) {
        completedRepsTextField.text = "\(completedReps)"
    }
    let doneButton = Button.buttonForSetCell(title: "Done")
    var isDone: Bool {
        get { return set.setStatus == .done }
        set {
            set.managedObjectContext?.perform {
                self.set.setStatus = newValue ? .done : .incomplete
                try! self.set.managedObjectContext?.save()
            }
            changeIsDone(newValue)
        }
    }
    func changeIsDone(_ isDone: Bool) {
        if isDone {
            completedWeight = targetWeight
            completedReps = targetReps
        }
        doneButton.setAttributedTitle(isDone ? "Done" : " ")
    }
    var hasFailed: Bool {
        get { return set.setStatus == .fail }
        set {
            set.managedObjectContext?.perform {
                self.set.setStatus = newValue ? .fail : .incomplete
                try! self.set.managedObjectContext?.save()
            }
            changeHasFailed(newValue)
        }
    }
    func changeHasFailed(_ hasFailed: Bool) {
        failureStackView.isHidden = !hasFailed
        failureStackView.setStandardBorder()
        completedRepsTextField.setStandardBorder()
        completedWeightTextField.setStandardBorder()
        doneButton.isHidden = hasFailed
        if hasFailed {
            doneButton.setAttributedTitle(" ")
        }
    }
    
    
    let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: Double((UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)!) * Lets.keyboardToViewRatio))
    var currentlyEditing: UITextField?
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
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
            if (textField.text == nil || textField.text == ""), let ph = textField.placeholder, let phValue = Int(ph) {
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
            if hasFailed {
                currentlyEditing = completedWeightTextField
            } else {
                currentlyEditing = nil
                delegate?.cellShouldJumpToNextTextField(self)
            }
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
    
}

class Button: UIButton {
    func setAttributedTitle(_ title: String) {
        let attributes = [NSFontAttributeName : Theme.Fonts.title, NSForegroundColorAttributeName : UIColor.black]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedString, for: UIControlState())
    }
    static func buttonForSetCell(title: String) -> Button {
        let button = Button()
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.setAttributedTitle(title)
        button.addTarget(button, action: #selector(Button.callAction(_:)), for: .touchUpInside)
        return button
    }
    
    var actionClosure: ((_ button: Button) -> ())!
    func callAction(_ button: Button) {
        actionClosure(button)
    }
}


extension WorkoutSetCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentlyEditing = textField
        if textField === completedWeightTextField {
            textField.text = nil
            textField.placeholder = String(targetWeight)
        } else if let text = textField.text {
            textField.placeholder = text
            textField.text = nil
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if currentlyEditing === textField {
            currentlyEditing = nil
        }
        
        let value = Int(textField.text!) ?? Int(textField.placeholder!) ?? 0
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
    }
}

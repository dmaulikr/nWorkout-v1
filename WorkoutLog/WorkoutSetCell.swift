import UIKit

class WorkoutSetCell: SetCell {
    
    var workoutSet: WorkoutSet { return set as! WorkoutSet }
    
    override var set: nSet! {
        didSet {
            changeTargetWeight(Int(workoutSet.targetWeight))
            changeTargetReps(Int(workoutSet.targetReps))
            changeCompletedWeight(Int(workoutSet.completedWeight))
            changeCompletedReps(Int(workoutSet.completedReps))
            changeIsDone(workoutSet.setStatus == .done)
            changeHasFailed(workoutSet.setStatus == .fail)
        }
    }
    var failureStackView: UIStackView
    
    var activeTextFields: [UITextField] { return [targetWeightTextField, targetRepsTextField] + (hasFailed ? [completedWeightTextField, completedRepsTextField] : []) }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        let completedWeightLabel = UILabel(text: "weight", textAlignment: .center, numberOfLines: 1, font: Theme.Fonts.tableHeader, borderColor: UIColor.darkGray.cgColor, borderWidth: 1)
        let completedRepsLabel = UILabel(text: "reps", textAlignment: .center, numberOfLines: 1, font: Theme.Fonts.tableHeader, borderColor: UIColor.darkGray.cgColor, borderWidth: 1)
        let weightStackView = UIStackView(arrangedSubviews: [completedWeightLabel,completedWeightTextField], axis: .vertical, spacing: 1, distribution: .fill)
        let repsStackView = UIStackView(arrangedSubviews: [completedRepsLabel,completedRepsTextField], axis: .vertical, spacing: 1, distribution: .fill)
        failureStackView = UIStackView(arrangedSubviews: [weightStackView,repsStackView], axis: .horizontal, spacing: 1, distribution: .fillEqually)
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        
        layer.borderWidth = 0
        
        textFields = [targetWeightTextField, targetRepsTextField, completedWeightTextField, completedRepsTextField]
        //Configure TextFields
        textFields.forEach { textField in
            textField.borderStyle = .none
            textField.textAlignment = .center
            textField.delegate = self
            textField.inputView = keyboardView
            textField.placeholder = "0"
        }
        
        keyboardView.delegate = self
        
        let visibles: [UIView] = [targetWeightTextField, targetRepsTextField, doneButton, completedWeightTextField, completedWeightLabel, completedRepsTextField, completedRepsLabel, failButton, doneButton, noteButton]
        visibles.forEach { visible in
            visible.backgroundColor = .white
        }
        
        let views: [UIView] = [targetWeightTextField,targetRepsTextField,doneButton,failureStackView]
        
        
        let stackView = UIStackView(arrangedSubviews: views, axis: .horizontal, spacing: 2, distribution: .fillEqually)
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(noteButton)
        noteButton.translatesAutoresizingMaskIntoConstraints = false
        noteButton.setContentHuggingPriority(1000, for: .horizontal)
        contentView.addSubview(failButton)
        failButton.translatesAutoresizingMaskIntoConstraints = false
        failButton.setContentHuggingPriority(1000, for: .horizontal)
        failButton.actionClosure = { [unowned self] button in
            self.hasFailed = !self.hasFailed
        }
        
        doneButton.backgroundColor = .white
        doneButton.actionClosure = { [unowned self] button in
            self.isDone = !self.isDone
        }
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 1),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            stackView.rightAnchor.constraint(equalTo: failButton.leftAnchor, constant: -2),
            failButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            failButton.rightAnchor.constraint(equalTo: noteButton.leftAnchor, constant: -2),
            failButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            noteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            noteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -1),
            noteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            noteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
    }
    
    
    let noteButton = Button.buttonForSetCell(title: "n")
    let failButton = Button.buttonForSetCell(title: "f")
    
    
    let targetWeightTextField = UITextField()
    var targetWeight: Int {
        get { return Int(workoutSet.targetWeight) }
        set {
            set.managedObjectContext?.perform {
                self.workoutSet.targetWeight = Int16(newValue)
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
        get { return Int(workoutSet.targetReps) }
        set {
            set.managedObjectContext?.perform {
                self.workoutSet.targetReps = Int16(newValue)
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
        get { return Int(workoutSet.completedWeight) }
        set {
            set.managedObjectContext?.performAndWait {
                self.workoutSet.completedWeight = Int16(newValue)
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
        get { return Int(workoutSet.completedReps) }
        set {
            set.managedObjectContext?.perform {
                self.workoutSet.completedReps = Int16(newValue)
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
        get { return workoutSet.setStatus == .done }
        set {
            set.managedObjectContext?.perform {
                self.workoutSet.setStatus = newValue ? .done : .incomplete
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
        get { return workoutSet.setStatus == .fail }
        set {
            set.managedObjectContext?.perform {
                self.workoutSet.setStatus = newValue ? .fail : .incomplete
                try! self.set.managedObjectContext?.save()
            }
            changeHasFailed(newValue)
        }
    }
    func changeHasFailed(_ hasFailed: Bool) {
        failureStackView.isHidden = !hasFailed
        doneButton.isHidden = hasFailed
        if hasFailed {
            doneButton.setAttributedTitle(" ")
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension WorkoutSetCell: KeyboardDelegate {
    
    func keyWasTapped(character: String) {
        guard let currentlyEditing = currentlyEditing, let text = currentlyEditing.text else { fatalError() }
        currentlyEditing.text = text + character
        textFieldDidChange(textField: currentlyEditing)
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
        guard let currentlyEditing = currentlyEditing, let idx = activeTextFields.index(of: currentlyEditing) else { fatalError() }
        if idx < (activeTextFields.count - 1) {
            let nextIdx = activeTextFields.index(after: idx)
            let nextTF = activeTextFields[nextIdx]
            self.currentlyEditing = nextTF
            nextTF.becomeFirstResponder()
        } else {
            self.currentlyEditing = nil
            jumpToNextSet(self)
        }
    }
    
}

final class RepsOrWeightTextField: UITextField {
    
    var repsOrWeight: Int! {
        didSet { didChange(repsOrWeight) }
    }
    
    var didChange: ((_ newValue: Int) -> ())!
    
    init() {
        super.init(frame: CGRect())
        clearButtonMode = .whileEditing
     
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension WorkoutSetCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = textField.text
        textField.text = nil
        return true
    }
    
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

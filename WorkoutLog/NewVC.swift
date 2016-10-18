import UIKit
import CoreData



class NewVC<Type: ManagedObject>: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    let context = CoreData.shared.context
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    var nameTextField = UITextField()
    var okayButton = UIButton(type: .system)
    
    init(type: Type.Type, placeholder: String, barButtonItem: UIBarButtonItem, callback: ((Type) -> ())?) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
        nameTextField.placeholder = placeholder
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 250, height: 150)
        popoverPresentationController?.delegate = self
        popoverPresentationController?.barButtonItem = barButtonItem
    }
    
    var callback: ((Type) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func okayPressed() {
        var object: Type?
        context.performAndWait {
            object = Type(context: self.context)
            object?.setValue(self.nameTextField.text, forKey: "name")
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        presentingViewController?.dismiss(animated: true) {
            self.callback?(object!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        nameTextField.placeholder = "Insert name here..."
        nameTextField.borderStyle = .roundedRect
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        
        okayButton.setTitle("Okay", for: UIControlState())
        okayButton.addTarget(self, action: #selector(okayPressed), for: .touchUpInside)
        okayButton.tintColor = Theme.Colors.foreground
        okayButton.layer.borderWidth = 1
        okayButton.layer.borderColor = Theme.Colors.foreground.cgColor
        okayButton.layer.cornerRadius = 5
        
        let stackView = StackView(arrangedSubviews: [nameTextField,okayButton], axis: .vertical, spacing: 8, distribution: .fillEqually)
        
        view.addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        
        //view.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        NSLayoutConstraint.activate(constraints)
        
        nameTextField.becomeFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            let alert = UIAlertController(title: "Name missing...", message: "Please insert a name.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
            return false
        } else {
            okayPressed()
            return true
        }
    }
}

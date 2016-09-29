import UIKit
import CoreData

class NoteVC<Type: ManagedObject>: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let context = CoreData.shared.context
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    var noteTextView = UITextView()
    var okayButton = UIButton(type: .system)
    var object: Type
    
    init(object: Type, placeholder: String, button: UIButton, callback: ((Type) -> ())?) {
        self.callback = callback
        self.object = object
        super.init(nibName: nil, bundle: nil)
        noteTextView.text = object.value(forKey: "note") as? String ?? "Type a note here."
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 180, height: 200)
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceView = button
        popoverPresentationController?.sourceRect = button.bounds
    }
    
    var callback: ((Type) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func okayPressed() {
        object.managedObjectContext?.performAndWait {
            
            self.object.setValue(self.noteTextView.text, forKey: "note")
            do {
                try self.object.managedObjectContext?.save()
            } catch {
                print(error: error)
            }
        }
        presentingViewController?.dismiss(animated: true) {
            self.callback?(self.object)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        okayButton.setTitle("Okay", for: UIControlState())
        okayButton.addTarget(self, action: #selector(okayPressed), for: .touchUpInside)
        okayButton.tintColor = Theme.Colors.foreground.color
        okayButton.layer.borderWidth = 1
        okayButton.layer.borderColor = Theme.Colors.foreground.color.cgColor
        okayButton.layer.cornerRadius = 5
        okayButton.frame = CGRect(x: 0, y: 250, width: 100, height: 40)

        
        noteTextView.layer.borderColor = Theme.Colors.foreground.color.cgColor
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.cornerRadius = 5
        
        view.addSubview(noteTextView)
        view.addSubview(okayButton)
        
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(noteTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8))
        constraints.append(noteTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8))
        constraints.append(noteTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8))
        constraints.append(okayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(okayButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 8))
        constraints.append(okayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8))
        constraints.append(okayButton.widthAnchor.constraint(equalTo: noteTextView.widthAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}


class NewVC<Type: ManagedObject>: UIViewController, UIPopoverPresentationControllerDelegate {
    
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
        
        okayButton.setTitle("Okay", for: UIControlState())
        okayButton.addTarget(self, action: #selector(okayPressed), for: .touchUpInside)
        okayButton.tintColor = Theme.Colors.foreground.color
        okayButton.layer.borderWidth = 1
        okayButton.layer.borderColor = Theme.Colors.foreground.color.cgColor
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
        
    }
}

import UIKit

class NoteVC<Type: ManagedObject>: UIViewController, UIPopoverPresentationControllerDelegate, HasContext, UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type a note here." {
            textView.text = ""
        }
    }
    
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
        noteTextView.delegate = self
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
        okayButton.tintColor = Theme.Colors.foreground
        okayButton.layer.borderWidth = 2
        okayButton.layer.borderColor = Theme.Colors.foreground.cgColor
        okayButton.layer.cornerRadius = 9
        okayButton.frame = CGRect(x: 0, y: 250, width: 100, height: 40)
        
        
        noteTextView.layer.borderColor = Theme.Colors.foreground.cgColor
        noteTextView.layer.borderWidth = 2
        noteTextView.layer.cornerRadius = 9
        
        view.addSubview(noteTextView)
        view.addSubview(okayButton)
        
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(noteTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2))
        constraints.append(noteTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2))
        constraints.append(noteTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2))
        constraints.append(okayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(okayButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 8))
        constraints.append(okayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2))
        constraints.append(okayButton.widthAnchor.constraint(equalTo: noteTextView.widthAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

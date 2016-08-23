import UIKit
import CoreData


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
        isModalInPopover = true
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
        
        
        let frame = view.frame
        
        let newFrame = CGRect(x: 0, y: 0, width: frame.width / 2.0, height: nameTextField.frame.height)
        nameTextField.frame = newFrame
        
        let stackView = UIStackView(arrangedSubviews: [nameTextField, okayButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        
        view.addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: 250, height: 300)
        
        //view.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}

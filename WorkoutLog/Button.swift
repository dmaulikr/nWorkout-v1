import UIKit

class Button: UIButton {
    
    var attributes = [NSFontAttributeName : Theme.Fonts.title, NSForegroundColorAttributeName : UIColor.black]
    
    func setAttributedTitle(_ title: String) {
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

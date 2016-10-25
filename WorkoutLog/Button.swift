import UIKit

class Button: UIButton {
    
    var attributes = [NSFontAttributeName : Theme.Fonts.title, NSForegroundColorAttributeName : UIColor.black]
    
    func setAttributedTitle(_ title: String) {
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedString, for: UIControlState())
    }
    static func buttonForSetCell(title: String) -> Button {
        let button = Button()

        button.setAttributedTitle(title)
        return button
    }
    
    init() {
        super.init(frame: CGRect())
        addTarget(self, action: #selector(Button.callAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var actionClosure: ((_ button: Button) -> ())!
    func callAction(_ button: Button) {
        actionClosure(button)
    }
}

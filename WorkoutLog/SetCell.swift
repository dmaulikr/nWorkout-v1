import UIKit

class SetCell: UITableViewCell, ConfigurableCell {
    typealias DataSource = nSet
    func configureForObject(object: nSet, at indexPath: IndexPath) {
        textFields.forEach {
            $0.placeholder = "0"
        }
        set = object
    }
    var textFields: [UITextField]!
    var set: nSet!
    
    var jumpToNextSet: ((_ innerCell: SetCell) -> ())!
    
    let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 1, height: Double((UIApplication.shared.windows.first?.rootViewController?.view.frame.size.height)!) * Lets.keyboardToViewRatio))
    var currentlyEditing: UITextField?
}


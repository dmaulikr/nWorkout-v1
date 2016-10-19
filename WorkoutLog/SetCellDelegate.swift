import UIKit

protocol SetCellDelegate: class {
    func cellShouldJumpToNextTextField(_ cell: UITableViewCell)
    func setCell(_ setCell: SetCell, didTap button: UIButton, for object: ManagedObject)
}

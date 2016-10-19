import UIKit

protocol LiftCellDelegate: class {
    func cellShouldJumpToNewSet(for cell: TableViewCellWithTableView, atInner innerIndexPath: IndexPath) -> UITableViewCell
}

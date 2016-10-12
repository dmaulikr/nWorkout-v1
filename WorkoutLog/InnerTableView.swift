import UIKit


class InnerTableView: UITableView {
    weak var outerCell: TableViewCellWithTableView!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        tableFooterView = UIView()
        backgroundColor = Theme.Colors.innerTableViewBackgroundColor.color
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        isScrollEnabled = false
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 2.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

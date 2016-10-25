import UIKit

extension UITableView {

    static func outerTableView(style: UITableViewStyle = .plain) -> UITableView {
        let tv = UITableView(frame: CGRect(), style: style)
        tv.tableFooterView = UIView()
        tv.backgroundView = UIView()
        
        tv.separatorStyle = .none
        
        return tv
    }
    static func innerTableView() -> UITableView {
        let tv = UITableView(frame: CGRect(), style: .plain)
        
        tv.tableFooterView = UIView()
        tv.backgroundColor = Theme.Colors.innerTableViewBackground
        
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tv.isScrollEnabled = false
        tv.layer.borderColor = UIColor.black.cgColor
        tv.layer.borderWidth = 2.0
        
        tv.separatorStyle = .none
        
        return tv
        
    }
}

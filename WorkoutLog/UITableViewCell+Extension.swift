import UIKit

extension UITableViewCell {
    static func innerTableViewCell(reuse: String?) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuse)

        cell.textLabel?.font = Theme.Fonts.title
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.layer.borderColor = UIColor.white.cgColor
        cell.textLabel?.layer.cornerRadius = 5
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        cell.backgroundColor = nil
        cell.textLabel?.font = Theme.Fonts.title
        
        return cell
    }
    
    static func outerTableViewCell(reuse: String?) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuse)
        cell.backgroundColor = Theme.Colors.background
        return cell
    }
    
}

import UIKit

class InnerTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.font = Theme.Fonts.title
        textLabel?.textAlignment = .center
        textLabel?.layer.borderColor = UIColor.white.cgColor
        textLabel?.layer.cornerRadius = 5
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

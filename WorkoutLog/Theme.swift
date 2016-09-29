import UIKit

struct Theme {
    static func setupAppearances() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSFontAttributeName: Fonts.boldTitleFont.font,
            NSForegroundColorAttributeName: Colors.tintColor.color
        ]
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.foreground.color
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.foreground.color
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        let attr = [ NSFontAttributeName: Fonts.titleFont.font ]
        barButtonItemAppearance.setTitleTextAttributes(attr, for: UIControlState())
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.backgroundColor.color
        
        let innerCellAppearance = InnerTableViewCell.appearance()
        innerCellAppearance.backgroundColor = nil
        innerCellAppearance.textLabel?.font = Fonts.titleFont.font
        
        let outerCellAppearance = OuterTableViewCell.appearance()
        outerCellAppearance.backgroundColor = Colors.backgroundColor.color
        
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.font = Fonts.titleFont.font
    }
    
    enum Colors {
        case outerTableViewBackgroundColor
        case innerTableViewBackgroundColor
        
        case tintColor
        case backgroundColor
        case lightBackgroundColor
        case sectionHeader
        case foreground
        case lightTextColor
        
        
        var color: UIColor {
            switch self {
            case .outerTableViewBackgroundColor: return #colorLiteral(red: 0.9386536593, green: 0.9386536593, blue: 0.9386536593, alpha: 1)
            case .innerTableViewBackgroundColor: return #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
                
            case .tintColor: return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .backgroundColor: return #colorLiteral(red: 0.9386536593, green: 0.9386536593, blue: 0.9386536593, alpha: 1)
            case .lightBackgroundColor: return #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
            case .sectionHeader: return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) //UIColor(red: 0.16, green: 0.15, blue: 0.25, alpha: 1)
            case .foreground: return #colorLiteral(red: 0.2131301963, green: 0.3175341896, blue: 0.3524125648, alpha: 1) //UIColor(red: 0.26, green: 0.25, blue: 0.37, alpha: 1)
            case .lightTextColor: return UIColor(red: 0.64, green: 0.65, blue: 0.8, alpha: 1)
            }
        }
    }
    enum Fonts {
        case boldTitleFont
        case titleFont
        case subTitleFont
        
        case tableHeaderFont
        case cellNameLabelFont
        
        var font: UIFont {
            switch self {
            case .boldTitleFont: return UIFont(name: "Copperplate-Bold", size: 17)!
            case .titleFont: return UIFont(name: "Copperplate", size: 16)!
            case .subTitleFont: return UIFont(name: "Copperplate", size: 13)!
                
            case .tableHeaderFont: return UIFont(name: "Copperplate", size: 10)!
            case .cellNameLabelFont: return UIFont(name: "Copperplate", size: 16)!
            }
        }
    }
}

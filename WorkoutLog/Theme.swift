import UIKit

struct Theme {
    static func setupAppearances() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSFontAttributeName: Fonts.boldTitle,
            NSForegroundColorAttributeName: Colors.tintColor.color
        ]
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.foreground.color
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.foreground.color
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        let attr = [ NSFontAttributeName: Fonts.title ]
        barButtonItemAppearance.setTitleTextAttributes(attr, for: UIControlState())
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.backgroundColor.color
        
        let innerCellAppearance = InnerTableViewCell.appearance()
        innerCellAppearance.backgroundColor = nil
        innerCellAppearance.textLabel?.font = Fonts.title
        
        let outerCellAppearance = OuterTableViewCell.appearance()
        outerCellAppearance.backgroundColor = Colors.backgroundColor.color
        
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.font = Fonts.title
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
    struct Fonts {
        static let boldTitle = UIFont.boldSystemFont(ofSize: 17)
        static let title = UIFont.boldSystemFont(ofSize: 16)
        static let subtitle = UIFont.boldSystemFont(ofSize: 13)
        
        static let tableHeader = UIFont.boldSystemFont(ofSize: 10)
        static let cellNameLabel = UIFont.boldSystemFont(ofSize: 16)
    }
}

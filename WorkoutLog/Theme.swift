import UIKit

struct Theme {
    enum Colors {
        case tintColor
        case backgroundColor
        case sectionHeader
        case foreground
        case lightTextColor
        
        
        var color: UIColor {
            switch self {
            case .tintColor: return UIColor(red: 0.97, green: 0.9, blue: 0, alpha: 1)
            case .backgroundColor: return #colorLiteral(red: 0.9386536593, green: 0.9386536593, blue: 0.9386536593, alpha: 1)
            case .sectionHeader: return UIColor(red: 0.16, green: 0.15, blue: 0.25, alpha: 1)
            case .foreground: return UIColor(red: 0.26, green: 0.25, blue: 0.37, alpha: 1)
            case .lightTextColor: return UIColor(red: 0.64, green: 0.65, blue: 0.8, alpha: 1)
            }
        }
    }
    enum Fonts {
        case titleFont
        case boldTitleFont
        case tableHeaderFont
        
        var font: UIFont { 
            switch self {
            case .boldTitleFont: return UIFont(name: "Copperplate-Bold", size: 17)!
            case .titleFont: return UIFont(name: "Copperplate", size: 16)!
            case .tableHeaderFont: return UIFont(name: "Copperplate", size: 10)!
            }
        }
    }
}

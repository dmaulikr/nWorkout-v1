import UIKit

extension UILabel {
    
    convenience init(text: String, textAlignment: NSTextAlignment, numberOfLines: Int, font: UIFont, borderColor: CGColor? = nil, borderWidth: CGFloat = 0) {
        self.init(frame: CGRect())
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.font = font
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }

    convenience init(tableHeaderStyleWith string: String, borderColor: CGColor? = UIColor.lightGray.cgColor, borderWidth: CGFloat = 1) {
        self.init(text: string, textAlignment: .center, numberOfLines: 0, font: Theme.Fonts.tableHeader, borderColor: borderColor, borderWidth: borderWidth)
    }
    convenience init(cellNameLabelStyleWith string: String) {
        self.init(text: string, textAlignment: .left, numberOfLines: 1, font: Theme.Fonts.cellNameLabel, borderColor: nil, borderWidth: 0)
    }
    
    
}

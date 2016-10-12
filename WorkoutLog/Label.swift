import UIKit

class Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.init(text: string, textAlignment: .center, numberOfLines: 0, font: Theme.Fonts.tableHeaderFont.font, borderColor: borderColor, borderWidth: borderWidth)
    }
    convenience init(cellNameLabelStyleWith string: String) {
        self.init(text: string, textAlignment: .left, numberOfLines: 1, font: Theme.Fonts.cellNameLabelFont.font, borderColor: nil, borderWidth: 0)
    }
    
    
}

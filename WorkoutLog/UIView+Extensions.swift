import UIKit

extension UIView {
    func constrainAnchors(to view: UIView, constant: CGFloat) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant))
        constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: constant))
        constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: constant))
        constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant))
        return constraints
    }
}

extension UIView {
    func setBorder(color: UIColor, radius: CGFloat, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.cornerRadius = radius
        layer.borderWidth = width
    }
    
    func setStandardBorder() {
        setBorder(color: .darkGray, radius: 0, width: 1)
    }
}

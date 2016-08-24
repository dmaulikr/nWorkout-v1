import UIKit

extension UIView {
    func constrainAnchors(to view: UIView, constant: CGFloat) {
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: constant).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
}

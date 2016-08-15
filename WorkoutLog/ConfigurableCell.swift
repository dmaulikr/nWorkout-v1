import UIKit

protocol ConfigurableCell {
    associatedtype DataSource
    func configureForObject(object: DataSource)
}


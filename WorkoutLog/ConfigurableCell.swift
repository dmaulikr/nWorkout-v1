import Foundation

protocol ConfigurableCell {
    associatedtype DataSource
    func configureForObject(object: DataSource)
}

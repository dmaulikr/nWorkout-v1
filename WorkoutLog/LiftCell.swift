import UIKit
import CoreData

extension Lift: DataProvider {
    
    func object(at indexPath: IndexPath) -> LSet {
        guard let sets = sets else { fatalError() }
        return sets.object(at: indexPath.row) as! LSet
    }
    func numberOfItems(inSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        if let sets = sets {
            return sets.count
        } else {
            return 0
        }
    }
    func numberOfSections() -> Int {
        return 2
    }
}

class LiftCell: TableViewCellWithTableView {
        
 }

extension LiftCell: ConfigurableCell {
    func configureForObject(object: Lift, at indexPath: IndexPath) {
        //
    }
}

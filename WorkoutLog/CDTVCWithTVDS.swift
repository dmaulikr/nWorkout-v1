import UIKit
import CoreData

class CDTVCWithTVDS<Type: NSManagedObject, Cell: UITableViewCell> : TVCWithTVDS<FetchedResultsDataProvider<Type>, Type, Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        let request = Type.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = Lets.CDTVCWithTVDSBatchSize
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
    }
    

    //DataSourceDelegate
    //Has to be here to be overrideable

    override func canEditRow(at: IndexPath) -> Bool {
        print("Implement \(#function)")
        return false
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        print("Implement \(#function)")
    }
}

extension CDTVCWithTVDS: DataProviderDelegate {
    typealias Object = Workout
    func dataProviderDidUpdate(updates: [DataProviderUpdate]?) {
        dataSource.processUpdates(updates: updates)
    }
}

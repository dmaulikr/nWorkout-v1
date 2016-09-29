import Foundation
import CoreData

class FetchedResultsDataProvider<Type: ManagedObject>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    init(fetchedResultsController: NSFetchedResultsController<Type>, delegate: DataProviderDelegate?) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }    
    
    // MARK: DataProvider
    func object(at indexPath: IndexPath) -> Type {
        return fetchedResultsController.object(at: indexPath)
    }
    func numberOfItems(inSection section: Int) -> Int {
        guard let sec = fetchedResultsController.sections?[section] else { return 0 }
        return sec.numberOfObjects
    }
    func numberOfSections() -> Int {
        guard let secs = fetchedResultsController.sections else { return 0 }
        return secs.count
    }    
    
    // MARK: Private
    private let fetchedResultsController: NSFetchedResultsController<Type>
    private let delegate: DataProviderDelegate?
    private var updates: [DataProviderUpdate] = []
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should not be nil") }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should not be nil") }
            let object = self.object(at: indexPath)
            updates.append(.update(indexPath, object))
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should not be nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should not be nil") }
            updates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.delete(indexPath))
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataProviderDidUpdate(updates: updates)
    }
}

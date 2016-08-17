import UIKit
import CoreData

class VCWithContext: UIViewController {
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
}

class TVCWithContext: UITableViewController {
    lazy var context: NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }()
}

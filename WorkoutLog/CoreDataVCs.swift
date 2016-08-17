import UIKit
import CoreData

class VCWithContext: UIViewController {
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let context: NSManagedObjectContext
}

class TVCWithContext: UITableViewController {
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let context: NSManagedObjectContext
}

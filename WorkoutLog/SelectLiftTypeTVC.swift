import UIKit
import CoreData



class SelectLiftTypeTVC<Type: ManagedObject>: UITableViewController, HasContext, NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        default: fatalError()
        }
    }
    
    let callback: (Type) -> ()
    
    init(callback: @escaping (Type) -> ()) {
        self.callback = callback
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var frc: NSFetchedResultsController<LiftType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        title = "Select Exercise"
        
        let request = LiftType.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = Lets.selectLiftTypeBatchSize
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newButtonPushed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPushed))
    }
    func cancelButtonPushed() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func newButtonPushed() {
        let newvc = NewVC(type: LiftType.self, placeholder: "Enter name here...", barButtonItem: navigationItem.rightBarButtonItem!, callback: doNothing)
        present(newvc, animated: true, completion: nil)
    }
    func doNothing(liftType: LiftType) {
//        try! frc.performFetch()
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections![0].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = frc.object(at: indexPath).name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLiftType = frc.object(at: indexPath)
        var object: Type?
        context.performAndWait {
            object = Type(context: self.context)
            object?.setValue(selectedLiftType.name, forKey: "name")
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        self.callback(object!)
        presentingViewController?.dismiss(animated: true) {
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(frc.fetchedObjects!.count)
            let object = frc.object(at: indexPath)
            context.performAndWait {
                self.context.delete(object)
                do {
                    try self.context.save()
                } catch {
                    print(error: error)
                }
            }
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}

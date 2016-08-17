import UIKit
import CoreData

class SelectWorkoutTVC: TVCWithContext {
    
    var frc: NSFetchedResultsController<Routine>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let request = Routine.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try! frc.performFetch()
    }
}



// MARK: UITableViewDataSource
extension SelectWorkoutTVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return frc.sections![0].numberOfObjects
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Blank workout"
        } else {
            cell.textLabel?.text = frc.fetchedObjects![indexPath.row].name
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectWorkoutTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wtvc = WorkoutTVC()
        switch (indexPath.row, indexPath.section) {
        case (0, 0):
            context.performAndWait {
                wtvc.source = Workout(context: self.context)
                wtvc.source.date = NSDate()
                do {
                    try self.context.save()
                } catch {
                    print(error)
                }
            }
        case (let row, 1):
            context.performAndWait {
                wtvc.source = self.frc.fetchedObjects![row].toWorkout()
                wtvc.source.date = NSDate()
                do {
                    try self.context.save()
                } catch {
                    print(error)
                }
            }
        default:
            assertionFailure("shouldn't happen")
        }
        navigationController?.pushViewController(wtvc, animated: true)
    }
}

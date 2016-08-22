import UIKit
import CoreData

class SelectWorkoutTVC: TVCWithContext {
    
    var frc: NSFetchedResultsController<Routine>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let request = Routine.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = Lets.selectWorkoutBatchSize
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try! frc.performFetch()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPushed))
    }
    
    func cancelButtonPushed() {
        self.navigationController?.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
        self.navigationController?.tabBarItem.title = "new"
        presentingViewController?.dismiss(animated: true) {
            
        }
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
            cell.textLabel?.text = Lets.blankWorkoutText
        } else {
            cell.textLabel?.text = frc.fetchedObjects![indexPath.row].name
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectWorkoutTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var workout: Workout?
        switch (indexPath.row, indexPath.section) {
        case (0, 0):
            context.performAndWait {
                workout = Workout(context: self.context)
                do {
                    try self.context.save()
                } catch {
                    print(error)
                }
            }
        case (let row, 1):
            context.performAndWait {
                workout = self.frc.fetchedObjects![row].toWorkout()
                do {
                    try self.context.save()
                } catch {
                    print(error)
                }
            }
        default:
            assertionFailure("shouldn't happen")
        }
        workout!.date = NSDate()
        let dummyNavBarItem = (UIApplication.shared.delegate as! AppDelegate).dummy.tabBarItem!
        dummyNavBarItem.image = #imageLiteral(resourceName: "show")
        dummyNavBarItem.title = "show"

        let wtvc = WorkoutTVC(dataProvider: workout!)
        wtvc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "hide", style: .plain, target: wtvc, action: #selector(wtvc.hideButtonPushed))
        navigationController?.pushViewController(wtvc, animated: true)
    }
}

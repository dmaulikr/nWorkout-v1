import UIKit
import CoreData

class SelectWorkoutTVC: UITableViewController {
    
    let context = CoreData.shared.context
    
    var frc: NSFetchedResultsController<Routine>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = Theme.Colors.lightBackgroundColor.color
        cell.textLabel?.font = Theme.Fonts.titleFont.font
        cell.detailTextLabel?.font = Theme.Fonts.subTitleFont.font
        if indexPath.section == 0 {
            cell.textLabel?.text = Lets.blankWorkoutText
            cell.detailTextLabel?.text = "Start a workout with no preset lifts."
        } else {
            let routine = frc.fetchedObjects![indexPath.row]
            cell.textLabel?.text = routine.name!
            let lifts = routine.lifts?.array as! [RoutineLift]
            let label = lifts.map { $0.name! }.joined(separator: ", ")
            cell.detailTextLabel?.text = label
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Default"
        case 1:
            return "Choose from your routines"
        default:
            fatalError()
        }
    }
}

// MARK: UITableViewDelegate
extension SelectWorkoutTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var workout: Workout?
        context.performAndWait {
            switch (indexPath.row, indexPath.section) {
            case (0, 0):
                workout = Workout(context: self.context)
            case (let row, 1):
                workout = self.frc.fetchedObjects![row].toWorkout()
                
            default:
                fatalError()    
            }
            workout!.date = Date()
            do {
                try self.context.save()
            } catch {
                print("===============ERROR==============")
                print(error)
            }
        }
        let wtvc = WorkoutTVC(dataProvider: workout!)
        let dummyNavBarItem = (UIApplication.shared.delegate as! AppDelegate).appCoordinator.dummy.tabBarItem!
        dummyNavBarItem.image = #imageLiteral(resourceName: "show")
        dummyNavBarItem.title = "show"
        wtvc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "hide", style: .plain, target: wtvc, action: #selector(wtvc.hideButtonPushed))
        navigationController?.pushViewController(wtvc, animated: true)
    }
}

import UIKit
import CoreData

class StatisticsTVC: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! frc?.performFetch()
        tableView.reloadData()
    }
    
    let context = CoreData.shared.context
    
    init() {
        super.init(style: .plain)
    }
    override func loadView() {
        tableView = UITableView.outerTableView(style: .grouped)
        view = tableVeiew
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let request = WorkoutLift.request
        request.fetchBatchSize = 10
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "workout.date", ascending: true)]
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        do {
            try frc?.performFetch()
        } catch {
            print(error: error)
        }
    }
    
    var frc: NSFetchedResultsController<WorkoutLift>?
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Performed Lifts"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = frc?.sections?.count
        return frc?.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lifts = frc?.sections?[indexPath.row]
        cell.textLabel?.text = (lifts?.name)! + " x \((lifts?.numberOfObjects)!)"
        cell.backgroundColor = Theme.Colors.background
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lifts = frc?.sections?[indexPath.row].objects as! [WorkoutLift]
        let olsvc = OneLiftStatisticsVC()
        olsvc.lifts = lifts
        navigationController?.pushViewController(olsvc, animated: true)
    }
}

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
        
        let sepIn = tableView.separatorInset
        let layMar = tableView.layoutMargins
        print("=====================================")
        print(sepIn, layMar)
        
        tableView = OuterTableView(frame: tableView.frame, style: .grouped)
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 20)
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Performed Lifts"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc?.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lifts = frc?.sections?[indexPath.row]
        cell.textLabel?.text = (lifts?.name)! + " x \((lifts?.numberOfObjects)!)"
        cell.backgroundColor = Theme.Colors.backgroundColor.color
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lifts = frc?.sections?[indexPath.row].objects as! [WorkoutLift]
        for lift in lifts {
            print(lift.name)
        }
        let olsvc = OneLiftStatisticsVC()
        olsvc.lifts = lifts
        navigationController?.pushViewController(olsvc, animated: true)
    }
}

class OneLiftStatisticsVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dateFormatter.dateFormat = "MMM d, H:mm a"
    }
    let dateFormatter = DateFormatter()
    var lifts: [WorkoutLift]!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = Theme.Colors.backgroundColor.color
        let sets = lifts[indexPath.row].sets?.array as! [WorkoutSet]
        cell.textLabel?.text = sets.map { "\($0.completedWeight) x \($0.completedReps)" }.joined(separator: ", ")
        cell.detailTextLabel?.text = dateFormatter.string(from: lifts[indexPath.row].date)
        return cell
    }
    
}

import UIKit

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
        cell.backgroundColor = Theme.Colors.background
        let sets = lifts[indexPath.row].sets?.array as! [WorkoutSet]
        cell.textLabel?.text = sets.map { "\($0.completedWeight) x \($0.completedReps)" }.joined(separator: ", ")
        cell.detailTextLabel?.text = dateFormatter.string(from: lifts[indexPath.row].date)
        return cell
    }
}

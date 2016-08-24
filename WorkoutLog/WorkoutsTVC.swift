import UIKit
import CoreData



class WorkoutsTVC: WorkoutsAndRoutinesTVC<Workout, WorkoutCell> {
    
    init() {
        let request = Workout.request
        request.fetchBatchSize = Lets.defaultBatchSize
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "complete == true")
        super.init(request: request)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = dataProvider.object(at: indexPath)
        let wtvc = WorkoutTVC(dataProvider: workout)
        navigationController?.pushViewController(wtvc, animated: true)
    }
    
    // TVCWTVDADS
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InnerTableViewCell
        let lift = dataProvider.object(at: cell.indexPath).object(at: indexPath)
        innerCell.textLabel?.text = lift.name! + " x \(lift.sets!.count)"
        return innerCell
    }
    
}

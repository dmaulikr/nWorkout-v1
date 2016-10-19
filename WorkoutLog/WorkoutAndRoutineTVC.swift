import UIKit
import CoreData
import CoreGraphics

class WorkoutAndRoutineTVC<Source: ManagedObject, Type: ManagedObject, Cell: TableViewCellWithTableView>: TableViewController<Source, Type, Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider, Source: DataProvider, Source.Object.Object: SetType {
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_: )), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    var defaultInsets: UIEdgeInsets!
    var keyboardHeight: CGFloat!
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            defaultInsets = tableView.contentInset
            let value = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            keyboardHeight = value?.height ?? view.frame.height * CGFloat(Lets.keyboardToViewRatio)

            
            let insets = UIEdgeInsets(top: defaultInsets.top, left: defaultInsets.left, bottom: keyboardHeight, right: defaultInsets.right)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    func keyboardDidShow(_ notification: Notification) {
        scrollToTextField()
    }
    
    func scrollToTextField() {
        print(#function)

        if let firstResponder = UIResponder.currentFirstResponder() as? UIView {
            let frFrame = firstResponder.frame
            let corrected = UIApplication.shared.keyWindow!.convert(frFrame, from: firstResponder.superview)
            let yRelativeToKeyboard = (view.frame.height - keyboardHeight) - (corrected.origin.y + corrected.height)
            print(yRelativeToKeyboard)
            if yRelativeToKeyboard < 0 {
                print("what")
                let frInViewsFrame = view.convert(frFrame, from: firstResponder.superview)
                let scrollPoint = CGPoint(x: 0, y: frInViewsFrame.origin.y - keyboardHeight - tableView.contentInset.top - frInViewsFrame.height - UIApplication.shared.statusBarFrame.height)
                tableView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            guard let defaultInsets = self.defaultInsets else { return }
            self.tableView.contentInset = defaultInsets
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func addButtonTapped() {
        let sltvc = SelectLiftTypeTVC(callback: insertNewObject)
        let nav = UINavigationController(rootViewController: sltvc)
        present(nav, animated: true)
    }
    func insertNewObject(object: Type) {
        var newIndexPath: IndexPath?
        context.performAndWait {
            newIndexPath = self.dataProvider.insert(object: object)
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        guard let indexPath = newIndexPath else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.numberOfItems(inSection: section)
        } else {
            let newWorkoutNav = (UIApplication.shared.delegate as! AppDelegate).appCoordinator.newWorkoutNav
            return navigationController == newWorkoutNav ? 3 : 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return super.tableView(tableView, cellForRowAt: indexPath)
        } else {
            let cell = UITableViewCell()
            switch indexPath.row {
            case 0: cell.textLabel?.text = "Add Lift"
            case 1: cell.textLabel?.text = "Finish Workout"
            case 2: cell.textLabel?.text = "Cancel Workout"
            default: fatalError()
            }
            return cell
        }
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataProvider.moveObject(at: sourceIndexPath, to: destinationIndexPath)
        setOuterIndexPaths()
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                addButtonTapped()
                tableView.deselectRow(at: indexPath, animated: true)
            default: fatalError()
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    //TVCWTVDaDS
    override func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 2
    }
    override func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.object(at: cell.outerIndexPath).numberOfItems(inSection: section)
        } else {
            return 1
        }
    }
    override func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? {
        if innerIndexPath.section == 1 {
            return innerIndexPath
        } else {
            return nil
        }
    }
    func addNewSet(for cell: TableViewCellWithTableView, atInner innerIndexPath: IndexPath) -> UITableViewCell {
        cell.deselectRow(at: innerIndexPath, animated: true)
        var newInnerIndexPath: IndexPath?
        
        let lift = dataProvider.object(at: cell.outerIndexPath)
        let setCount = lift.numberOfItems(inSection: 0)
        let lastSet = setCount > 0 ? Optional.some(lift.object(at: IndexPath(row: setCount - 1, section: 0))) : nil
        
        context.performAndWait {
            var set = Type.Object(context: self.context)
            set.configure(weight: lastSet?.settableWeight ?? 0, reps: lastSet?.settableReps ?? 0)
            newInnerIndexPath = lift.insert(object: set)
            do {
                try self.context.save()
            } catch {
                print(error: error)
            }
        }
        guard let indexPath = newInnerIndexPath else { fatalError() }
        cell.insertRows(at: [indexPath], with: .automatic)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        return cell.innerCellForRow(atInner: indexPath)!
    }
    
    override func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) {
        guard innerIndexPath.section == 1 else { return }
        _ = addNewSet(for: cell, atInner: innerIndexPath)
    }
    override func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false } else { return true }
    }
    override func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let outerObject = dataProvider.object(at: cell.outerIndexPath)
        let toRemove = outerObject.object(at: indexPath)
        outerObject.remove(object: toRemove)
        
        tableView.beginUpdates()
        cell.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    //Dummy since Swift can't find Subclass implementation without something to override.
    override func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError() }
    override func cellClassForInnerTableView(for cell: TableViewCellWithTableView) -> [AnyClass] {
        return super.cellClassForInnerTableView(for: cell)
    }
    override func reuseIdentifierForInnerTableView(for cell: TableViewCellWithTableView) -> [String] {
        return super.reuseIdentifierForInnerTableView(for: cell)
    }
    
    
}

extension WorkoutAndRoutineTVC: LiftCellDelegate {
    func cellShouldJumpToNewSet(for cell: TableViewCellWithTableView, atInner innerIndexPath: IndexPath) -> UITableViewCell {
        let newSetCell = addNewSet(for: cell, atInner: innerIndexPath) as! SetCell
        newSetCell.textFields.forEach {
            $0.placeholder = $0.text
            $0.text = nil
        }
        return newSetCell as! UITableViewCell
    }
}

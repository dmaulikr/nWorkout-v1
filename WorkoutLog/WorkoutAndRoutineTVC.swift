import UIKit
import CoreData

class WorkoutAndRoutineTVC<Source: NSManagedObject, Type: NSManagedObject, Cell: TableViewCellWithTableView>: TVCWithTVDS<Source, Type, Cell> where Type: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider, Source: DataProvider {
    
    func stringForButton() -> String {
        return Lets.newLiftBarButtonText
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: stringForButton(), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    func addButtonTapped() {
        let nlvc = NewVC(type: Type.self, placeholder: Lets.newLiftPlaceholderText, barButtonItem: navigationItem.rightBarButtonItem!, callback: insertNewObject)
        present(nlvc, animated: true)
    }

    func insertNewObject(object: Type) {
        var newIndexPath: IndexPath?
        
        context.performAndWait {
            newIndexPath = self.dataProvider.insert(object: object)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
        guard let indexPath = newIndexPath else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func canEditRow(at: IndexPath) -> Bool {
        return true
    }
    override func commit(_ editingStyle: UITableViewCellEditingStyle, for indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.dataProvider.managedObjectContext?.performAndWait {
                let object = self.dataSource.dataProvider.object(at: indexPath)
                self.dataSource.dataProvider.managedObjectContext?.delete(object)
                do {
                    try self.dataSource.dataProvider.managedObjectContext!.save()
                } catch let error {
                    print(error)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    override func cell(forRowAt indexPath: IndexPath, identifier: String) -> Cell? {
        return Cell(delegateAndDataSource: self, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataProvider.object(at: indexPath).numberOfItems(inSection: 0)) * CGFloat(Lets.subTVCellSize) + CGFloat(Lets.heightBetweenTopOfCellAndTV)
    }
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 2
    }
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProvider.object(at: cell.indexPath).numberOfItems(inSection: section)
        } else {
            return 1
        }
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let innerCell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return innerCell
    }
}

extension WorkoutAndRoutineTVC: TableViewCellWithTableViewDataSource {}
extension WorkoutAndRoutineTVC: TableViewCellWithTableViewDelegate {}


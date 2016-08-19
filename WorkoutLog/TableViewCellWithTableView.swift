import UIKit

struct Person {
    var name: String
    var dogs: [String]
}
class ViewController: UITableViewController {
    
    let people: [Person] = [Person(name: "Nathan", dogs: ["Muffin","Riley","Belle"]), Person(name: "Mom", dogs: ["Muffin","Riley","Belle"])]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCellWithTableView<SubCell, ViewController>.self, forCellReuseIdentifier: "cell")
    }
}

//MARK: MainTableView
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCellWithTableView<UITableViewCell, ViewController>(delegateAndDataSource: self, indexPath: indexPath, subTableViewCellType: UITableViewCell.self)
        
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }
}
//MARK: CellTableView
extension ViewController: TableViewCellWithTableViewDataSourceAndDelegate {
    internal func rowAt(outerIndexPath: IndexPath, cellForRowAtInner innerIndexPath: IndexPath) -> UITableViewCell {
        let outerCell = tableView.cellForRow(at: outerIndexPath) as! TableViewCellWithTableView<UITableViewCell, ViewController>
        let innerCell = outerCell.tableView.dequeueReusableCell(withIdentifier: "cell", for: innerIndexPath)
        let dog = people[outerIndexPath.row].dogs[innerIndexPath.row]
        innerCell.textLabel?.text = dog
        return innerCell
    }

    internal func rowAt(outerIndexPath: IndexPath, numberOfRowsInSection section: Int) -> Int {
        return people[outerIndexPath.row].dogs.count
    }

    typealias SubCell = UITableViewCell

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func cell(_ cell: TableViewCellWithTableView<UITableViewCell, ViewController>, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dog = people[cell.indexPath.row].dogs[indexPath.row]
        tvcell.textLabel?.text = dog
        return tvcell
    }
}

//MARK: TableViewCelLWithTableView
class TableViewCellWithTableView<SubCell: UITableViewCell, Delegate>: UITableViewCell where Delegate: TableViewCellWithTableViewDataSourceAndDelegate{
    var indexPath: IndexPath!
    weak var delegate: Delegate?
    
    var gapBetweenTopAndTableView: CGFloat = 80.0
    let tableView: UITableView
    lazy var subTableViewDelegateAndDataSource: SubTableViewDelegateAndDataSource<SubCell, Delegate> = {
        return SubTableViewDelegateAndDataSource(cell: self)
    }()
    
    required init(delegateAndDataSource: Delegate,
                  indexPath: IndexPath, subTableViewCellType: SubCell.Type) {
        self.indexPath = indexPath
        self.delegate = delegateAndDataSource
        
        tableView = UITableView(frame: CGRect(), style: .plain)
        super.init(style: .default, reuseIdentifier: "")
        
        subTableViewDelegateAndDataSource.delegate = delegateAndDataSource
        
        tableView.register(subTableViewCellType, forCellReuseIdentifier: "cell")
        tableView.delegate = subTableViewDelegateAndDataSource
        tableView.dataSource = subTableViewDelegateAndDataSource
        
        contentView.addSubview(tableView)
        
        configureTableView()
        
        tableView.reloadData()
    }
    
    func configureTableView() {
        0
        tableView.layer.borderWidth = 2.0
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        //        tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: gapBetweenTopAndTableView).isActive = true
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 45)
        heightConstraint.isActive = true
    }
    
    var heightConstraint: NSLayoutConstraint!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        fatalError("init(style:reuseIdentifier) has not been implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: TableViewCellWithTableView Delegate and DataSource
protocol TableViewCellWithTableViewDataSourceAndDelegate: class {
    associatedtype SubCell: UITableViewCell
    //DataSourceRequired
    func rowAt(outerIndexPath: IndexPath, numberOfRowsInSection section: Int) -> Int
    func rowAt(outerIndexPath: IndexPath, cellForRowAtInner innerIndexPath: IndexPath) -> UITableViewCell
    //DataSourceOptional
    func numberOfSections(forRowAtOuter outerIndexPath: IndexPath) -> Int
    func rowAt(outerIndexPath: IndexPath, didCommit editingSyle: UITableViewCellEditingStyle, forRowAtInner innerIndexPath: IndexPath)
    func rowAt(outerIndexPath: IndexPath, canEditRowAtInner innerIndexPath: IndexPath) -> Bool
    //DelegateOptional
    func rowAt(outerIndexPath: IndexPath, didSelectRowAtInner innerIndexPath: IndexPath)
}
extension TableViewCellWithTableViewDataSourceAndDelegate {
    //DataSource
    func numberOfSections(forRowAtOuter outerIndexPath: IndexPath) -> Int { return 1 }
    func rowAt(outerIndexPath: IndexPath, didCommit editingSyle: UITableViewCellEditingStyle, forRowAtInner innerIndexPath: IndexPath) { }
    func rowAt(outerIndexPath: IndexPath, canEditRowAtInner innerIndexPath: IndexPath) -> Bool { return false }
    //Delegate
    func rowAt(outerIndexPath: IndexPath, didSelectRowAtInner innerIndexPath: IndexPath) { }
}


//MARK: SubTableViewDelegateAndDataSource
class SubTableViewDelegateAndDataSource<SubCell: UITableViewCell, Delegate>: NSObject, UITableViewDataSource, UITableViewDelegate where Delegate: TableViewCellWithTableViewDataSourceAndDelegate  {
    var cell: TableViewCellWithTableView<SubCell, Delegate>
    init(cell: TableViewCellWithTableView<SubCell, Delegate>) {
        self.cell = cell
    }
    
    weak var delegate: Delegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.numberOfSections(forRowAtOuter: cell.indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.rowAt(outerIndexPath: cell.indexPath, numberOfRowsInSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate else { fatalError("134") }
        return delegate.rowAt(outerIndexPath: cell.indexPath, cellForRowAtInner: indexPath)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.rowAt(outerIndexPath: cell.indexPath, didCommit: editingStyle, forRowAtInner: indexPath)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.rowAt(outerIndexPath: cell.indexPath, canEditRowAtInner: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        return delegate.rowAt(outerIndexPath: cell.indexPath, didSelectRowAtInner: indexPath)
    }
}


















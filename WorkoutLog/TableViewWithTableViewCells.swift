import UIKit

struct Person {
    var name: String
    var dogs: [String]
}
class ViewController: UITableViewController {
    
    let people: [Person] = [Person(name: "Nathan", dogs: ["Muffin","Riley","Belle"]), Person(name: "Mom", dogs: ["Muffin","Riley","Belle"])]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCellWithTableView.self, forCellReuseIdentifier: "cell")
    }
}

//MARK: MainTableView
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCellWithTableView(delegateAndDataSource: self, indexPath: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }
}
extension ViewController: TableViewCellWithTableViewDelegate {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
//MARK: CellTableView
extension ViewController: TableViewCellWithTableViewDataSource {
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        return people[cell.indexPath.row].dogs.count
    }
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcell = cell.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dog = people[cell.indexPath.row].dogs[indexPath.row]
        tvcell.textLabel?.text = dog
        return tvcell
    }
}

//MARK: TableViewCelLWithTableView
class TableViewCellWithTableView: UITableViewCell {
    var indexPath: IndexPath!
    weak var delegate: TableViewCellWithTableViewDelegate?
    weak var dataSource: TableViewCellWithTableViewDataSource?
    
    var gapBetweenTopAndTableView: CGFloat = 80.0
    let tableView: UITableView
    lazy var subTableViewDelegateAndDataSource: SubTableViewDelegateAndDataSource = {
        return SubTableViewDelegateAndDataSource(cell: self)
    }()

    required init(delegateAndDataSource: TableViewCellWithTableViewDelegate & TableViewCellWithTableViewDataSource,
         indexPath: IndexPath) {
        self.indexPath = indexPath
        self.delegate = delegateAndDataSource
        self.dataSource = delegateAndDataSource
        
        tableView = UITableView(frame: CGRect(), style: .plain)
        super.init(style: .default, reuseIdentifier: "")
        
        subTableViewDelegateAndDataSource.delegate = delegateAndDataSource
        subTableViewDelegateAndDataSource.dataSource = delegateAndDataSource
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(Lets.subTVCellSize))
        heightConstraint.isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = subTableViewDelegateAndDataSource
        tableView.dataSource = subTableViewDelegateAndDataSource

        contentView.addSubview(tableView)

        customizeTableView()
        tableView.reloadData()
        
        let numberOfSections = tableView.numberOfSections
        var cellCounts = [Int]()
        for i in 0..<numberOfSections {
            cellCounts.append(tableView.numberOfRows(inSection: i))
        }
        var heights = [CGFloat]()
        for i in 0..<cellCounts.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: i)) {
                heights.append(cell.frame.height * CGFloat(cellCounts[i]))
            }
        }
        let height = heights.reduce(0) { $0 + $1 }

        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height + CGFloat(Lets.heightBetweenTopOfCellAndTV))
        
        heightConstraint.constant = height
        tableView.reloadData()
    }
    

    
    
    private func customizeTableView() {
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.layer.borderWidth = 2.0
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        //        tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: gapBetweenTopAndTableView).isActive = true
        
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
protocol TableViewCellWithTableViewDataSource: class {
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func cell(_ cell: TableViewCellWithTableView, didCommit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool
}
extension TableViewCellWithTableViewDataSource {
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return 1
    }
    func cell(_ cell: TableViewCellWithTableView, didCommit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //
    }
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
protocol TableViewCellWithTableViewDelegate: class {
    
}

//MARK: SubTableViewDelegateAndDataSource
class SubTableViewDelegateAndDataSource: NSObject {
    var cell: TableViewCellWithTableView
    init(cell: TableViewCellWithTableView) {
        self.cell = cell
    }
    
    weak var dataSource: TableViewCellWithTableViewDataSource?
    weak var delegate: TableViewCellWithTableViewDelegate?
}
extension SubTableViewDelegateAndDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.numberOfSections(in: cell)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.cell(cell, numberOfRowsInSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else { fatalError("134") }
        return dataSource.cell(cell, cellForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataSource?.cell(cell, didCommit: editingStyle, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let dataSource = dataSource else { return false }
        return dataSource.cell(cell, canEditRowAt: indexPath)
    }
}
extension SubTableViewDelegateAndDataSource: UITableViewDelegate {
}

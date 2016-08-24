import UIKit


//MARK: TableViewCelLWithTableView
class TableViewCellWithTableView: OuterTableViewCell {
    func didInsertRows(at indexPaths: [IndexPath]) {
        updateTableViewHeight()
    }
    func didDeleteRows(at indexPaths: [IndexPath]) {
        updateTableViewHeight()
    }
    func updateTableViewHeight() {
        let numberOfSections = tableView.numberOfSections
        var cellCounts = [Int]()
        for i in 0..<numberOfSections {
            cellCounts.append(tableView.numberOfRows(inSection: i))
        }
        let height = cellCounts.reduce(CGFloat(0)) { $0 + CGFloat($1) * CGFloat(Lets.subTVCellSize) }
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: height + CGFloat(Lets.heightBetweenTopOfCellAndTV))
        self.heightConstraint.constant = height
        
    }
    var delegate: TableViewCellWithTableViewDelegateAndDataSource?
    
    var gapBetweenTopAndTableView: CGFloat = 80.0
    let tableView: InnerTableView
    lazy var subTableViewDelegateAndDataSource: SubTableViewDelegateAndDataSource = {
        return SubTableViewDelegateAndDataSource(cell: self)
    }()
    
    required init(delegateAndDataSource: TableViewCellWithTableViewDelegateAndDataSource) {

        self.delegate = delegateAndDataSource
        self.tableView = InnerTableView(frame: CGRect(), style: .plain)
        
        super.init(style: .default, reuseIdentifier: "")
        subTableViewDelegateAndDataSource.delegate = delegateAndDataSource
        
        tableView.outerCell = self
        tableView.delegate = subTableViewDelegateAndDataSource
        tableView.dataSource = subTableViewDelegateAndDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contentView.addSubview(tableView)
        
        var constraints = [NSLayoutConstraint]()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8))
        constraints.append(tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8))
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(Lets.subTVCellSize))
        constraints.append(heightConstraint)
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.reloadData()
        updateTableViewHeight()
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
protocol TableViewCellWithTableViewDelegateAndDataSource: class {
    //Required
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int)
    //Optional
    func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat
    func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath?
    func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath)
}
extension TableViewCellWithTableViewDelegateAndDataSource {
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int { return 1 }
    func cell(_ cell: TableViewCellWithTableView, commit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat { return cell.tableView.rowHeight }
    func cell(_ cell: TableViewCellWithTableView, willSelectRowAtInner innerIndexPath: IndexPath) -> IndexPath? { return innerIndexPath }
    func cell(_ cell: TableViewCellWithTableView, didSelectRowAtInner innerIndexPath: IndexPath) {  }
}


//MARK: SubTableViewDelegateAndDataSource
class SubTableViewDelegateAndDataSource: NSObject {
    var cell: TableViewCellWithTableView
    init(cell: TableViewCellWithTableView) {
        self.cell = cell
    }
    
    var delegate: TableViewCellWithTableViewDelegateAndDataSource?
}
extension SubTableViewDelegateAndDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.numberOfSections(in: cell)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = delegate else { return 0 }
        delegate.cell(cell, registerInnerCellForSection: section)
        return delegate.cell(cell, numberOfRowsInSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate else { fatalError("134") }
        return delegate.cell(cell, cellForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.cell(cell, commit: editingStyle, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.cell(cell, canEditRowAt: indexPath)
    }
}
extension SubTableViewDelegateAndDataSource: UITableViewDelegate {
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let delegate = delegate else { return 0.0 }
        return delegate.cell(cell, heightForRowAtInner: indexPath)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let delegate = delegate else { return indexPath }
        return delegate.cell(cell, willSelectRowAtInner: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        return delegate.cell(cell, didSelectRowAtInner: indexPath)
    }
    
    //IMPLEMENT THIS
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

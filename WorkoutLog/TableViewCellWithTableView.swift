import UIKit

//MARK: TableViewCelLWithTableView
class TableViewCellWithTableView: UITableViewCell {
    var indexPath: IndexPath!
    var delegate: AnyTVCWTVDADS<Int>?
    
    var gapBetweenTopAndTableView: CGFloat = 80.0
    let tableView: UITableView
    lazy var subTableViewDelegateAndDataSource: SubTableViewDelegateAndDataSource = {
        return SubTableViewDelegateAndDataSource(cell: self)
    }()
    
    required init(delegateAndDataSource: AnyTVCWTVDADS<Int>,
                  indexPath: IndexPath) {
        self.indexPath = indexPath
        self.delegate = delegateAndDataSource
        
        tableView = UITableView(frame: CGRect(), style: .plain)
        super.init(style: .default, reuseIdentifier: "")
        
        subTableViewDelegateAndDataSource.delegate = delegateAndDataSource
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

        let height = cellCounts.reduce(CGFloat(0)) { $0 + CGFloat($1) * CGFloat(Lets.subTVCellSize) }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height + CGFloat(Lets.heightBetweenTopOfCellAndTV))
        
        heightConstraint.constant = height
        tableView.reloadData()
    }
    
    private func customizeTableView() {
        tableView.isScrollEnabled = false
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


class AnyTVCWTVDADS<InnerCell>: TableViewCellWithTableViewDelegateAndDataSource {
    
    func thing(innerCell: InnerCell) { }
    init<DADS: TableViewCellWithTableViewDelegateAndDataSource>(dads: DADS) where DADS.InnerCell == InnerCell {
        numberOfSections = dads.numberOfSections
        numberOfRowsInSection = dads.cell
        cellForRowAt = dads.cell
        didCommit = dads.cell
        canEditRowAt = dads.cell
        registerInnerCellForSection = dads.cell
        heightForRowAtInner = dads.cell
    }
    private let numberOfSections: ((TableViewCellWithTableView) -> Int)
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int {
        return numberOfSections(cell)
    }
    private let numberOfRowsInSection: ((TableViewCellWithTableView, Int) -> Int)
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(cell,section)
    }
    private let cellForRowAt: ((TableViewCellWithTableView, IndexPath) -> UITableViewCell)
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAt(cell,indexPath)
    }
    private let didCommit: ((TableViewCellWithTableView, UITableViewCellEditingStyle, IndexPath) -> ())
    func cell(_ cell: TableViewCellWithTableView, didCommit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        didCommit(cell,editingSyle,indexPath)
    }
    private let canEditRowAt: ((TableViewCellWithTableView, IndexPath) -> Bool)
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return canEditRowAt(cell,indexPath)
    }
    private let registerInnerCellForSection: ((TableViewCellWithTableView, Int) -> ())
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int) {
        registerInnerCellForSection(cell,section)
    }
    private let heightForRowAtInner: ((TableViewCellWithTableView, IndexPath) -> CGFloat)
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat {
        return heightForRowAtInner(cell,innerIndexPath)
    }
}


protocol TableViewCellWithTableViewDelegateAndDataSource: class {
    associatedtype InnerCell
    func thing(innerCell: InnerCell)
    //Required
    func cell(_ cell: TableViewCellWithTableView, numberOfRowsInSection section: Int) -> Int
    func cell(_ cell: TableViewCellWithTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func cell(_ cell: TableViewCellWithTableView, registerInnerCellForSection section: Int)
    //Optional
    func cell(_ cell: TableViewCellWithTableView, didCommit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat
}
extension TableViewCellWithTableViewDelegateAndDataSource {
    func thing(innerCell: InnerCell) { }
    func numberOfSections(in cell: TableViewCellWithTableView) -> Int { return 1 }
    func cell(_ cell: TableViewCellWithTableView, didCommit editingSyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    func cell(_ cell: TableViewCellWithTableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
    func cell(_ cell: TableViewCellWithTableView, heightForRowAtInner innerIndexPath: IndexPath) -> CGFloat { return cell.tableView.rowHeight }
}


//MARK: SubTableViewDelegateAndDataSource
class SubTableViewDelegateAndDataSource: NSObject {
    var cell: TableViewCellWithTableView
    init(cell: TableViewCellWithTableView) {
        self.cell = cell
    }
    
    var delegate: AnyTVCWTVDADS<Int>?
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
        delegate?.cell(cell, didCommit: editingStyle, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.cell(cell, canEditRowAt: indexPath)
    }
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let delegate = delegate else { return 0.0 }
        return delegate.cell(cell, heightForRowAtInner: indexPath)
    }
}
extension SubTableViewDelegateAndDataSource: UITableViewDelegate {
}

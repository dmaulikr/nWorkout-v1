import UIKit
import CoreData



class CDandTVwithinTVCellTVC<Source: DataProvider, Type: NSManagedObject, Cell: UITableViewCell>: TVCWithTableViewInCells<Source,Type,Cell>
where Type: ManagedObjectType, Source: ManagedObjectType, Cell: ConfigurableCell, Cell.DataSource == Type, Source.Object == Type, Type: DataProvider {
    
    
    
}

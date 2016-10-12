import Foundation
import CoreGraphics

struct Lets {
    static let dateString = "EEEE - MM/d/yyyy - h:mm a"
    static let timeZoneAbbreviation = "EST"
    
    static let liftCellNameLabelHeight: CGFloat = 25
    static let liftCellTableHeaderHeight: CGFloat = 23
    static let innerTableHeaderViewHeight: CGFloat = 23 + 25 + 16
    static let subTVCellSize: CGFloat = 25
    
    
    static let newWorkoutBarButtonText = "New Workout"
    static let newLiftBarButtonText = "New Lift"
    static let addSetText = "Add set..."
    static let finishWorkout = "Finish Workout"
    
    static let keyboardToViewRatio = 0.4
    
    
    
    static let buffer: CGFloat = 8.0
    
    static let selectWorkoutBatchSize = 20
    static let defaultBatchSize = 10
 
    static let blankWorkoutText = "Blank Workout"
    
    static let tableCellAdditionAnimationDuration = 0.3
    
    static let newLiftPlaceholderText = "Lift name..."
    
    static let df: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Lets.dateString
        formatter.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        return formatter
    }()
}


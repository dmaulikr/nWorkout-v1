import Foundation

class Routine {
    var expanded = false
    var name = "Starting Strength 3x5"
    var workoutsAndDays = [(Workout,Day)]()
    
}

enum Day {
    case saturday, monday, tuesday, wednesday, thursday, friday, sunday
}

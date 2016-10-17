protocol SetType {
    mutating func configure(weight: Int, reps: Int)
    var settableWeight: Int { get set }
    var settableReps: Int { get set }
}

extension SetType {
    mutating func configure(weight: Int, reps: Int) {
        settableWeight = weight
        settableReps = reps
    }
}

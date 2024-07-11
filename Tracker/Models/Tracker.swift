import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [DaysOfWeek]
}

struct DaysOfWeek {
    let day: Days
    var isOn: Bool
}

enum Days: Int, CaseIterable {
    case monday = 2, tuesday = 3, wednesday = 4, thursday = 5, friday = 6, saturday = 7, sunday = 1
    
    func longFormat() -> String {
        switch self {
        case .monday:
            return NSLocalizedString("monday", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("thursday", comment: "")
        case .friday:
            return NSLocalizedString("friday", comment: "")
        case .saturday:
            return NSLocalizedString("saturday", comment: "")
        case .sunday:
            return NSLocalizedString("sunday", comment: "")
        }
    }
        
    func shortFormat() -> String {
        switch self {
        case .monday:
            return NSLocalizedString("mon", comment: "")
        case .tuesday:
            return NSLocalizedString("tue", comment: "")
        case .wednesday:
            return NSLocalizedString("wed", comment: "")
        case .thursday:
            return NSLocalizedString("thu", comment: "")
        case .friday:
            return NSLocalizedString("fri", comment: "")
        case .saturday:
            return NSLocalizedString("sat", comment: "")
        case .sunday:
            return NSLocalizedString("sun", comment: "")
        }
    }
}




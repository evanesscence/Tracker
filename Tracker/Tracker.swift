import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [DaysOfWeek]
}

struct DaysOfWeek {
    let day: String
    let isOn: Bool
}


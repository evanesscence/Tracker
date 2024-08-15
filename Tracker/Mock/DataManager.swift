import Foundation

class DataManager {
    static let shared = DataManager()
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            name: "Уборка",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Помыть посуду",
                    color: .tLightBlue,
                    emoji: "🍽️",
                    schedule: [DaysOfWeek(day: Days.friday, isOn: true), DaysOfWeek(day: Days.sunday, isOn: true)]
                ),
                Tracker(
                    id: UUID(),
                    name: "Погладить одежду",
                    color: .tPink,
                    emoji: "👔",
                    schedule: [DaysOfWeek(day: Days.tuesday, isOn: true)]
                )
            ]
        ),
        TrackerCategory(
            name: "Сделать уроки",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Математика",
                    color: .tMildBlue,
                    emoji: "🤯",
                    schedule: [DaysOfWeek(day: Days.monday, isOn: true), DaysOfWeek(day: Days.thursday, isOn: true)]
                ),
                Tracker(
                    id: UUID(),
                    name: "Литература",
                    color: .tBeige,
                    emoji: "📚",
                    schedule: [DaysOfWeek(day: Days.thursday, isOn: true)]
                ),
                Tracker(
                    id: UUID(),
                    name: "Физика",
                    color: .tPurple,
                    emoji: "🤓",
                    schedule: [DaysOfWeek(day: Days.friday, isOn: true)]
                )
            ]
        ),
        TrackerCategory(
            name: "Спорт",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Пробежка",
                    color: .tGreenBlue,
                    emoji: "🏃",
                    schedule: [DaysOfWeek(day: Days.saturday, isOn: true)]
                )
            ]
        )
    ]
}

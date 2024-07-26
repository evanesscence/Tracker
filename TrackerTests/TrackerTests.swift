import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackersCollectionNoCompletedCellLight() throws {
        let weekDayNumber = Calendar.current.component(.weekday, from: Date())
        var weekDay = Days.monday
        
        Days.allCases.forEach {
            if $0.rawValue == weekDayNumber {
                weekDay = $0
            }
        }
        
        let cell = TrackerCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 90))
        let tracker = Tracker(id: UUID(), name: "Test", color: .tBlack, emoji: "🥴", schedule: [DaysOfWeek(day: weekDay, isOn: true)])
        cell.configTracker(for: tracker, isCompletedToday: false, completedDays: 0, at: IndexPath(row: 0, section: 0), isTomorrow: false)
        
        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
}

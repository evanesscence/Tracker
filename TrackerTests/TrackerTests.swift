import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let vc = TrackersViewController()
        
        assertSnapshot(of: vc, as: .image)
    }
}

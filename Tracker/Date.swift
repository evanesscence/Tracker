//import Foundation
//
//extension Date {
//    func day() -> Int? {
//        guard let currentWeekDay = Calendar.current.dateComponents([.day], from: self).weekday else {
//            return 0
//        }
//        
//        var dayWeek: Days
//        for day in Days.allCases {
//            if currentWeekDay == day.rawValue {
//                dayWeek = day
//            }
//        }
//       
//        return dayWeek
//    }
//}
//

//import UIKit
//
//enum Properties: String, CaseIterable {
//    case category = "Категория"
//    case sсhedule = "Расписание"
//}
//
//class EventsItemController: UIViewController {
//    var selectedItem: String?
//    var property: Properties?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .tWhite
//        setupForChosenProperty()
//    }
//    
//    private func setupForChosenProperty() {
//        Properties.allCases.forEach {
//            if let selectedItem = selectedItem {
//                if selectedItem == $0.rawValue {
//                    property = $0
//                }
//            }
//        }
//        
//        switch property {
//        case .category:
//            showChosenItemController(for: CategoriesController())
//            break
//        case .sсhedule:
//            showChosenItemController(for: ScheduleController())
//            break
//        default:
//            break
//        }
//    }
//    
//    private func showChosenItemController(for vc: UIViewController) {
//        let navController = UINavigationController(rootViewController: vc)
//        show(navController, animated: false)
//    }
//}
//
//

//import UIKit
//
//final class TrackerContextMenuCreator {
//    func createMenu(for cell: TrackerCollectionViewCell) -> UIContextMenuConfiguration? {
//        let preview = TrackerContextMenuPreview(
//            color: cell.getColor(),
//            emoji: cell.getEmoji(),
//            eventInfo: cell.getEventInfo(),
//            isPinned: cell.isPinned()
//        )
//        
//        let previewCell = TrackerContextMenuPreviewCell(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 90))
//        
//        
//        let pinTitle = cell.isPinned() ? NSLocalizedString("unpin", comment: "") : NSLocalizedString("pin", comment: "")
//        
//        let contextMenu = UIContextMenuConfiguration(
//            previewProvider: {
//                let viewController = UIViewController()
//                previewCell.setupCell(for: preview)
//                
//                viewController.view.addSubview(previewCell)
//                viewController.preferredContentSize = CGSize(
//                    width: previewCell.frame.width,
//                    height: previewCell.frame.height
//                )
//                
//                return viewController
//            },
//            
//            actionProvider: { actions in
//                return UIMenu(children: [
//                    UIAction(title: pinTitle) { _ in
//                        
//                        if pinTitle == NSLocalizedString("pin", comment: "") {
//                            cell.pinTracker()
//                            cell.setupPinnedTracker()
//                        } else {
//                            cell.unpinTracker()
//                            cell.setupUnpinnedTracker()
//                        }
//                        TrackersViewController().reloadData()
//                    },
//                    UIAction(title: NSLocalizedString("edit", comment: "")) { _ in
//                    },
//                    UIAction(title: NSLocalizedString("delete", comment: ""), attributes: .destructive) { _ in
//                        
//                    }
//                ])
//            })
//        return contextMenu
//    }
//}

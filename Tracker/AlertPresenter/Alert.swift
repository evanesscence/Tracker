import UIKit

struct AlertModel {
    let title: String?
    let message: String?
}

final class Alert {
    
    func showDeleteAlert(for model: AlertModel, action: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive, handler: action)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func showWarningAlert(for model: AlertModel, action: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: action)
        
        alert.addAction(deleteAction)
        
        return alert
    }
}

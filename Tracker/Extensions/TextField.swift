import UIKit

final class TextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width/2-26, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    }
}

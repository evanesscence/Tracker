import UIKit

final class Colors {
    let borderTopTabBarColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.lightGray                                    // светлый режим
        } else {
            return UIColor(red: 0.8, green: 0.5, blue: 0.8, alpha: 1)   // тёмный режим
        }
    }
}

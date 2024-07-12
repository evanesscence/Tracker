import Foundation

struct CollectionElements {
    let elementsName: String
    let elements: [String]
}

class UICollectionElements {
    static let shared = UICollectionElements()
    
    var elements: [CollectionElements] = [
        CollectionElements(
            elementsName: "Emoji",
            elements: [
                "🙂", "😻", "🌺", "🐶", "❤️", "😱",
                "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
        ]),
        
        CollectionElements(
            elementsName: NSLocalizedString("bgColorSection", comment: ""),
            elements:
                ["#FD4C49", "#FF881E", "#007BFA",
                 "#6E44FE", "#33CF69", "#E66DD4",
                 "#F9D4D4", "#34A7FE", "#46E69D",
                 "#35347C", "#FF674D", "#FF99CC",
                 "#F6C48B", "#7994F5", "#832CF1",
                 "#AD56DA", "#8D72E6", "#2FD058"
        ])
    ]
}

import Foundation

final class CategoryViewModel: Identifiable {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    var nameBinding: Binding<String>? {
        didSet {
            nameBinding?(name)
        }
    }
}

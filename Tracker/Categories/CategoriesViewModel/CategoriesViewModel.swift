import Foundation

typealias Binding<T> = (T) -> Void

final class CategoriesViewModel {
    weak var delegate: TrackerCategoryStoreDelegate?
    private var categoryStore: TrackerCategoryStore
    
    var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[TrackerCategory]>?

    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        categoryStore.delegate = self
        loadCategories()
    }
    
    func loadCategories() {
        categories = getCategoriesFromStore()
    }

    func getCategoriesFromStore() -> [TrackerCategory] {
        return categoryStore.trackers
    }
    
    func addNewCategory(category: TrackerCategory) {
        try? categoryStore.addNewCategory(category)
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore, with insertedIndex: IndexSet) {
        loadCategories()
    }
}
